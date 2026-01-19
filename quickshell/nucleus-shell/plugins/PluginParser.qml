import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
pragma Singleton

Item {
    id: root

    property alias model: pluginModel

    function isInstalled(id) {
        return PluginLoader.pluginNames.indexOf(id) !== -1;
    }

    function refresh() {
        pluginModel.clear();
        fetchProc.running = true;
    }

    function install(id) {
        runAction("install", id);
    }

    function uninstall(id) {
        runAction("uninstall", id);
    }

    function update(id) {
        runAction("update", id);
    }

    function runAction(action, id) {
        actionProc.command = ["bash", "-c", Directories.scriptsPath + "/plugins/plugins.sh " + action + " " + id];
        actionProc.running = true;
    }

    ListModel {
        id: pluginModel
    }

    Process {
        id: fetchProc

        running: true
        command: ["bash", "-c", Directories.scriptsPath + "/plugins/plugins.sh fetch all-machine"]

        stdout: SplitParser {
            onRead: (data) => {
                const lines = data.split("\n");
                for (let i = 0; i < lines.length; ++i) {
                    const line = lines[i].trim();
                    if (!line)
                        continue;

                    const parts = line.split("\t");
                    if (parts.length < 7)
                        continue;

                    const pid = parts[0];
                    pluginModel.append({
                        "id": pid,
                        "name": parts[1],
                        "version": parts[2],
                        "author": parts[3],
                        "description": parts[4],
                        "img": parts[5],
                        "repo": parts[6],
                        "installed": isInstalled(pid)
                    });
                }
            }
        }

    }

    Process {
        id: actionProc

        stdout: StdioCollector {
            onStreamFinished: {
                PluginLoader.reload();
                refresh();
            }
        }

    }

}
