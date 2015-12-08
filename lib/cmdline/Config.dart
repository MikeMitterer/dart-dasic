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

part of dasic.cmdline;

/**
 * Defines default-configurations.
 * Most of these configs can be overwritten by commandline args.
 */
class Config {
    final Logger _logger = new Logger("dasic.cmdline.Config");

    static const String _CONFIG_FOLDER     = ".dasic";

    final ArgResults _argResults;
    final Map<String,dynamic> _settings = new Map<String,dynamic>();

    Config(this._argResults) {

        _settings[Options._ARG_LOGLEVEL]            = 'info';

        _overwriteSettingsWithConfigFile();
        _overwriteSettingsWithArgResults();
    }

    String get configfolder => _CONFIG_FOLDER;

    String get configfile => "config.yaml";

    String get loglevel => _settings[Options._ARG_LOGLEVEL];

    List<String> get filestoscan => _argResults.rest;

    Map<String,String> get settings {
        final Map<String,String> settings = new Map<String,String>();

        settings["loglevel"]                                = loglevel;

        settings["Config folder"]                           = configfolder;
        settings["Config file"]                             = configfile;


        if(filestoscan.length > 0) {
            settings["Files to scan"]                        = filestoscan.join(", ");
        }

        return settings;
    }


    void printSettings() {

        int getMaxKeyLength() {
            int length = 0;
            settings.keys.forEach((final String key) => length = max(length,key.length));
            return length;
        }

        final int maxKeyLeght = getMaxKeyLength();

        String prepareKey(final String key) {
            return "${key[0].toUpperCase()}${key.substring(1)}:".padRight(maxKeyLeght + 1);
        }

        print("Settings:");
        settings.forEach((final String key,final String value) {
            print("    ${prepareKey(key)} $value");
        });
    }

    // -- private -------------------------------------------------------------

    void _overwriteSettingsWithArgResults() {

        if(_argResults.wasParsed(Options._ARG_LOGLEVEL)) {
            _settings[Options._ARG_LOGLEVEL] = _argResults[Options._ARG_LOGLEVEL];
        }

    }

    void _overwriteSettingsWithConfigFile() {
        final File file = new File("${configfolder}/${configfile}");
        if(!file.existsSync()) {
            return;
        }
        final yaml.YamlMap map = yaml.loadYaml(file.readAsStringSync());
        _settings.keys.forEach((final String key) {
            if(map != null && map.containsKey(key)) {
                _settings[key] = map[key];
                //print("Found $key in $configfile: ${map[key]}");
            }
        });
    }
}