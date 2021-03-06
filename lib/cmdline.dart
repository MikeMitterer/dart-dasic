/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

library dasic.cmdline;

import 'dart:io';

import 'dart:math';

import "package:yaml/yaml.dart" as yaml;
import 'package:args/args.dart';
import 'package:console_log_handler/print_log_handler.dart';
import 'package:validate/validate.dart';

import 'package:dasic/dasic.dart';

part "cmdline/Application.dart";
part "cmdline/Config.dart";
part "cmdline/Options.dart";