# Copyright 2016-2021 Swiss National Supercomputing Centre (CSCS/ETH Zurich)
# ReFrame Project Developers. See the top-level LICENSE file for details.
#
# SPDX-License-Identifier: BSD-3-Clause

import reframe as rfm
import reframe.utility.sanity as sn


@rfm.parameterized_test(['c'], ['cpp'])
class HelloMultiLangTest(rfm.RegressionTest):
    def __init__(self, lang):
        self.valid_systems = ['*']
        self.valid_prog_environs = ['*']
        self.sourcepath = f'hello.{lang}'
        self.sanity_patterns = sn.assert_found(r'Hello, World\!', self.stdout)
