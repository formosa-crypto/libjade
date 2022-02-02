"""
Checks SUPERCOP 'checksum*' (atm checksumbig)
"""

import hashlib
import os
import unittest

import pytest

import helpers
import libjade


@pytest.mark.parametrize(
    'implementation,test_dir,impl_path, init, destr',
    [(impl, *helpers.isolate_test_files(impl.path(), 'test_checksums_'))
     for impl in libjade.Scheme.all_supported_implementations()],
    ids=[str(impl) for impl in libjade.Scheme.all_supported_implementations()],
)

@helpers.filtered_test
def test_testvectors(implementation, impl_path, test_dir, init, destr):
    # TODO clean this
    if not implementation.supported_on_current_platform():
        raise unittest.SkipTest("Not supported on current platform")
    init()
    dest_dir = os.path.join(test_dir, 'bin')
    
    # check 'small' checksum
    helpers.make('checksumsmall',
                 TYPE=implementation.scheme.type,
                 SCHEME=implementation.scheme.name,
                 IMPLEMENTATION=implementation.name,
                 SCHEME_DIR=impl_path,
                 DEST_DIR=dest_dir,
                 working_dir=os.path.join(test_dir, 'test'))

    out = helpers.run_subprocess(
        [os.path.join(dest_dir, 'checksumsmall_{}_{}{}'.format(
            implementation.scheme.name_,
            implementation.name_,
            '.exe' if os.name == 'nt' else ''
        ))],
        print_output=False,
    ).replace('\r', '')
    assert(implementation.scheme.metadata()['checksumsmall'].lower()
           == out)

    # check 'big' checksum
    helpers.make('checksumbig',
                 TYPE=implementation.scheme.type,
                 SCHEME=implementation.scheme.name,
                 IMPLEMENTATION=implementation.name,
                 SCHEME_DIR=impl_path,
                 DEST_DIR=dest_dir,
                 working_dir=os.path.join(test_dir, 'test'))

    out = helpers.run_subprocess(
        [os.path.join(dest_dir, 'checksumbig_{}_{}{}'.format(
            implementation.scheme.name_,
            implementation.name_,
            '.exe' if os.name == 'nt' else ''
        ))],
        print_output=False,
    ).replace('\r', '')
    assert(implementation.scheme.metadata()['checksumbig'].lower()
           == out)

    destr()


if __name__ == '__main__':
    import sys
    pytest.main(sys.argv)
