# Copyright 2014 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

from mock import call, patch, Mock

import common
from webports import installed_package

test_info = '''\
NAME=foo
VERSION=bar
BUILD_ARCH=arm
BUILD_CONFIG=debug
BUILD_TOOLCHAIN=glibc
BUILD_SDK_VERSION=123
BUILD_NACLPORTS_REVISION=98765
'''


def CreateMockInstalledPackage():
  file_mock = common.MockFileObject(test_info)
  with patch('__builtin__.open', Mock(return_value=file_mock), create=True):
    return installed_package.InstalledPackage('dummy_file')


class TestInstalledPackage(common.NaclportsTest):

  @patch('webports.util.Log', Mock())
  @patch('webports.installed_package.RemoveFile')
  @patch('webports.installed_package.InstalledPackageIterator',
      Mock(return_value=[]))
  @patch('os.path.lexists', Mock(return_value=True))
  @patch('os.path.exists', Mock(return_value=True))
  def testUninstall(self, remove_patch):  # pylint: disable=no-self-use
    pkg = CreateMockInstalledPackage()
    pkg.Files = Mock(return_value=['f1', 'f2'])
    pkg.Uninstall()

    # Assert that exactly 4 files we removed using RemoveFile
    calls = [call('/package/install/path/var/lib/npkg/foo.info'),
             call('/package/install/path/f1'),
             call('/package/install/path/f2'),
             call('/package/install/path/var/lib/npkg/foo.list')]
    remove_patch.assert_has_calls(calls)
