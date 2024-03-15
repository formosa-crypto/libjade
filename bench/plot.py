#!/usr/bin/env python3

import csv
from pathlib import Path
from dataclasses import dataclass
from enum import IntEnum, Enum, auto
from matplotlib import pyplot as plt
import click


class OpType(IntEnum):
    OP1 = 1 # number_of_iterations, check_is_ok, sdev, mean, median, list_of_results
    OP2 = 2 # inlen, number_of_iterations, check_is_ok, sdev, mean, median, list_of_results 
    OP3 = 3 # outlen, inlen, number_of_iterations, check_is_ok, sdev, mean, median, list_of_results 


@dataclass(frozen=True)
class ImplFunction(object):
    name: str
    optype: OpType


class ImplType(Enum):
    crypto_hash = (ImplFunction("", OpType.OP2), )
    crypto_kem = (ImplFunction("keypair", OpType.OP1),
                  ImplFunction("keypair_derand", OpType.OP1),
                  ImplFunction("enc", OpType.OP1),
                  ImplFunction("enc_derand", OpType.OP1),
                  ImplFunction("dec", OpType.OP1))
    crypto_onetimeauth = (ImplFunction("", OpType.OP2), ImplFunction("verify", OpType.OP2))
    crypto_scalarmult = (ImplFunction("base", OpType.OP1), ImplFunction("", OpType.OP1))
    crypto_secretbox = (ImplFunction("", OpType.OP2), ImplFunction("open", OpType.OP2), ImplFunction("open_forgery", OpType.OP2))
    crypto_sign = (ImplFunction("keypair", OpType.OP1), ImplFunction("", OpType.OP2), ImplFunction("open", OpType.OP2))
    crypto_stream = (ImplFunction("", OpType.OP2), ImplFunction("xor", OpType.OP2))
    crypto_xof = (ImplFunction("", OpType.OP3), )


@dataclass
class Results(object):
    name: str
    """Name of the results config (machine/before/after/DOITM)."""
    type: ImplType
    """Implementation type (like crypto_kem, ...)."""
    impl: str
    """Implementation (like kyber512...)."""
    arch: str
    """Architecture (like amd64...)."""
    variant: str
    """The variant (like ref, avx, ...)."""
    func: ImplFunction
    """The function (like keypair gen, ...)."""
    data: list
    """The raw data."""

    def __str__(self) -> str:
        return f"{self.name} {self.type.name} {self.impl} {self.arch} {self.variant} {self.func.name} {self.func.optype.name}"

    def __repr__(self) -> str:
        s = str(self) + "\n"
        for l in self.data:
            s += ", ".join(map(str, l)) + "\n"
        return s


def plot_op1(ax, *results: Results):
    labels = []
    data = []
    for result in results:
        if not(result.data):
            print(f"Skipping {result}")
            continue
        for line in result.data:
            measurements = line[0]
            ok = line[1]
            sdev = line[2]
            mean = line[3]
            median = line[4]
            rest = line[5:]
            data.append(rest)
        labels.append(result.name)
    ax.boxplot(data, labels=labels)
    ax.set_ylabel("cycles")


def plot_op2(ax, *results: Results):
    for result in results:
        if not(result.data):
            print(f"Skipping {result}")
            continue
        lengths = []
        sdevs = []
        means = []
        for line in result.data:
            inlen = line[0]
            measurements = line[1]
            ok = line[2]
            sdev = line[3]
            mean = line[4]
            median = line[5]
            rest = line[6:]
            lengths.append(inlen)
            sdevs.append(sdev)
            means.append(mean)
        ax.plot(lengths, means, label=result.name)
    ax.legend(loc="best")
    ax.set_xlabel("inlen")
    ax.set_ylabel("cycles")


def plot_op3(ax, *results: Results):
    for result in results:
        if not(result.data):
            print(f"Skipping {result}")
            continue
        lengths = []
        sdevs = []
        means = []
        for line in result.data:
            outlen = line[0]
            inlen = line[1]
            measurements = line[2]
            ok = line[3]
            sdev = line[4]
            mean = line[5]
            median = line[6]
            rest = line[7:]
            lengths.append((outlen, inlen))
            sdevs.append(sdev)
            means.append(mean)
        ax.plot(lengths, means, label=result.name)
    ax.legend(loc="best")
    ax.set_xlabel("inlen")
    ax.set_ylabel("cycles")


def load_directory(directory: Path) -> list[Results]:
    bin_dir = directory / "bin"
    all_results = []
    for impl_type in ImplType:
        type_dir = bin_dir / impl_type.name
        # sign, kem and stream (except xsalsa20) have additional subdirectory for the primitive
        if impl_type in (ImplType.crypto_sign, ImplType.crypto_kem, ImplType.crypto_stream):
            top_levels = list(type_dir.iterdir())
            impl_dirs = sum(map(lambda top: list(top.iterdir()) if top.name != "xsalsa20" else [top], top_levels), [])
        else:
            impl_dirs = list(type_dir.iterdir())
        for impl_dir in impl_dirs:
            impl_name = impl_dir.name
            for arch_dir in impl_dir.iterdir():
                arch = arch_dir.name
                for variant_dir in arch_dir.iterdir():
                    variant = variant_dir.name
                    for fname in variant_dir.glob("*.csv"):
                        for func in impl_type.value:
                            func_name = f"{variant}_{func.name}" if func.name else variant
                            if str(fname).endswith(func_name + ".csv"):
                                break
                        else:
                            raise ValueError("Unknown function")
                        with fname.open("r") as f:
                            reader = csv.reader(f)
                            data = [list(map(lambda x: float(x.strip()) if "." in x else int(x.strip()), line)) for line in reader]
                            results = Results(directory.name, impl_type, impl_name, arch, variant, func, data)
                            all_results.append(results)
    return all_results


@click.command()
@click.argument("dirs", nargs=-1, type=click.Path(exists=True, file_okay=False, dir_okay=True, path_type=Path), required=True)
def main(dirs):
    # (ImplType, impl, arch, variant, func) -> list[Results]
    result_map = {}
    for directory in dirs:
        click.echo(f"Processing {directory}.")
        results = load_directory(directory)
        for r in results:
            ident = (r.type, r.impl, r.arch, r.variant, r.func)
            result_map.setdefault(ident, [])
            result_map[ident].append(r)

    # (ImplType, impl, arch, variant) -> (func -> list[Results])
    func_map = {}
    for ident, results in result_map.items():
        merged_ident = (ident[0], ident[1], ident[2], ident[3]) # all but the func
        func_map.setdefault(merged_ident, {})
        func_map[merged_ident][ident[4]] = results

    for ident, func_result_map in func_map.items():
        funcs = ident[0].value
        fig, axs = plt.subplots(len(funcs), figsize=(5, len(funcs)*4))
        if len(funcs) == 1:
            axs = [axs]
        for i, func in enumerate(funcs):
            results = func_result_map.get(func)
            if not results:
                continue
            ax = axs[i]
            if len(results) <= 1:
                print(f"Not enough results for {name}.")
                continue
            ax.set_title(func.name)
            if func.optype == OpType.OP1:
                plot_op1(ax, *results)
            elif func.optype == OpType.OP2:
                plot_op2(ax, *results)
            elif func.optype == OpType.OP3:
                plot_op3(ax, *results)
        name = f"{ident[0].name}_{ident[1]}_{ident[2]}_{ident[3]}"
        fname = name + ".png"
        fig.suptitle(name)
        fig.tight_layout()
        fig.savefig(fname, dpi=300)
        plt.close(fig)


if __name__ == "__main__":
    main()