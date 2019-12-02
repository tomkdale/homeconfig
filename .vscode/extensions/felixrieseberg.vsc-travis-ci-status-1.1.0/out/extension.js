"use strict";
var vscode_1 = require('vscode');
var travis_status_1 = require('./travis-status');
var indicator, proxySetup, proxyData;
function activate() {
    // Create File System Watcher
    var watcher = vscode_1.workspace.createFileSystemWatcher('.travis.yml', false, false, true);
    watcher.onDidChange(function (e) { return updateStatus(); });
    watcher.onDidCreate(function (e) { return updateStatus(); });
    // Register Commands
    vscode_1.commands.registerCommand('extension.updateTravis', function () { return updateStatus(); });
    vscode_1.commands.registerCommand('extension.openInTravis', function () { return openInTravis(); });
    // Check if file already present
    vscode_1.workspace.findFiles('.travis.yml', '', 1).then(function (result) {
        if (result && result.length > 0) {
            updateStatus();
        }
    });
}
exports.activate = activate;
// Helper Function
function updateStatus() {
    if (!proxySetup)
        setupProxy();
    indicator = indicator || new travis_status_1.default();
    indicator.updateStatus();
}
function openInTravis() {
    if (!proxySetup)
        setupProxy();
    indicator = indicator || new travis_status_1.default();
    indicator.openInTravis();
}
function setupProxy() {
    if (process.env && process.env.http_proxy) {
        // Seems like we have a proxy
        var match = process.env.http_proxy.match(/^(http:\/\/)?([^:\/]+)(:([0-9]+))?/i);
        var proxyData_1 = { host: null, port: null };
        if (match && match.length >= 3) {
            proxyData_1.host = match[2];
            proxyData_1.port = match[4] != null ? match[4] : 80;
        }
        if (proxyData_1.host && proxyData_1.port) {
            var globalTunnel = require('global-tunnel');
            globalTunnel.initialize({
                host: proxyData_1.host,
                port: proxyData_1.port
            });
        }
        else {
            // We have trouble getting ifnormation form the global http_proxy env variable
            vscode_1.window.showErrorMessage('Travis CI: HTTP Proxy settings detected, but we have trouble parsing the setting. The extension may not work properly.');
        }
    }
    proxySetup = true;
}
//# sourceMappingURL=extension.js.map