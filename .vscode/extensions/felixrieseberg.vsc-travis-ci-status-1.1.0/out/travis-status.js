"use strict";
var vscode_1 = require('vscode');
var path = require('path');
var fs = require('fs');
var Travis = require('travis-ci');
var Git = require('git-rev-2');
var TravisStatusIndicator = (function () {
    function TravisStatusIndicator() {
        this._useProxy = false;
        this._proxyData = { host: null, port: null };
        // Private variables for automatic status polling
        this._statusPollingTimeout = null;
        this._statusPolling = vscode_1.workspace.getConfiguration('travis').get('statusPolling');
        this._statusPollingInterval = vscode_1.workspace.getConfiguration('travis').get('statusPollingInterval');
        // Listen for changes to configuration
        vscode_1.workspace.onDidChangeConfiguration(this.updateStatusPollingConfiguration.bind(this));
    }
    TravisStatusIndicator.prototype.updateStatus = function () {
        var _this = this;
        if (!this._statusBarItem) {
            this._statusBarItem = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Left);
            this._statusBarItem.command = 'extension.updateTravis';
        }
        // Mark statusBarItem as 'loading'
        this._statusBarItem.text = 'Travis CI $(sync)';
        this._statusBarItem.tooltip = 'Fetching Travis CI status for this project...';
        if (this.isTravisProject()) {
            var userRepo_1 = this.getUserRepo();
            // Display Message Box if not actually a Travis
            if (!userRepo_1 || userRepo_1.length < 2 || userRepo_1[0].length === 0 || userRepo_1[1].length === 0) {
                this.displayError('Fetching Travis CI build status failed: Could not detect username and repository');
            }
            var username_1 = userRepo_1[0], repoName_1 = userRepo_1[1];
            //Get active branch
            Git.branch(vscode_1.workspace.rootPath, function (err1, currentActiveBranch) {
                //Get head commit hash
                Git.long(vscode_1.workspace.rootPath, function (err2, currentCommitSha) {
                    // Let's attempt getting a build status from Travis
                    _this.getTravis().repos(username_1, repoName_1).branches(currentActiveBranch).get(function (branchError, branchResponse) {
                        if (!branchError && branchResponse.commit.sha === currentCommitSha) {
                            var started = new Date(branchResponse.branch.started_at);
                            var state = branchResponse.branch.state;
                            var buildNumber = branchResponse.branch.number;
                            var durationInSeconds = branchResponse.branch.duration;
                            _this.show(durationInSeconds, state, buildNumber, started, currentCommitSha.substr(0, 7));
                        }
                        else {
                            _this.getTravis().repos(username_1, repoName_1).get(function (repoError, repoResponse) {
                                if (repoError)
                                    return _this.displayError("Travis could not find " + userRepo_1[0] + "/" + userRepo_1[1]);
                                if (!repoResponse || !repoResponse.repo)
                                    return _this.displayError('Travis CI could not find your repository.');
                                if (repoResponse.repo.last_build_number === null)
                                    return _this.displayError('Travis found your repository, but it never ran a test.');
                                var started = new Date(repoResponse.repo.last_build_started_at);
                                var state = repoResponse.repo.last_build_state;
                                var buildNumber = repoResponse.repo.last_build_number;
                                var durationInSeconds = repoResponse.repo.last_build_duration;
                                _this.show(durationInSeconds, state, buildNumber, started, 'master');
                            });
                        }
                    });
                });
            });
        }
        // Should the status be polled?
        if (this._statusPolling === true) {
            // Run the update function again in the specified number of seconds
            this._statusPollingTimeout = setTimeout(this.updateStatus.bind(this), this._statusPollingInterval * 1000);
        }
    };
    TravisStatusIndicator.prototype.show = function (buildDuration, state, buildNumber, started, identifier) {
        var duration = Math.round(buildDuration / 60).toString();
        duration += (duration === '1') ? ' minute' : ' minutes';
        var timeInfo = "Started: " + started.toLocaleDateString() + "\nDuration: " + duration;
        switch (state) {
            case 'passed':
                return this.displaySuccess("Build " + buildNumber + " has passed.\n" + timeInfo, identifier);
            case 'started':
                return this.displayRunning("Build " + buildNumber + " has started.\n" + timeInfo, identifier);
            case 'running':
                return this.displayRunning("Build " + buildNumber + " is currently running.\n" + timeInfo, identifier);
            case 'failed':
                return this.displayFailure("Build " + buildNumber + " failed.\n" + timeInfo, identifier);
            default:
                // Don't throw, but instead try to display something.
                return this.displayRunning("Build " + buildNumber + " has " + state + ". \n" + timeInfo, identifier);
        }
    };
    // Opens the current project on Travis
    TravisStatusIndicator.prototype.openInTravis = function () {
        if (!vscode_1.workspace || !vscode_1.workspace.rootPath || !this.isTravisProject())
            return;
        var open = require('open');
        var repo = this.getUserRepo();
        var base = "https://travis-ci";
        if (vscode_1.workspace.getConfiguration('travis')['pro']) {
            base += '.com/';
        }
        else {
            base += '.org/';
        }
        if (repo && repo.length === 2) {
            return open("" + base + repo[0] + "/" + repo[1]);
        }
    };
    // Check if a .travis.yml file is present, which indicates whether or not
    // this is a Travis project
    TravisStatusIndicator.prototype.isTravisProject = function () {
        if (!vscode_1.workspace || !vscode_1.workspace.rootPath)
            return false;
        var conf = path.join(vscode_1.workspace.rootPath, '.travis.yml');
        try {
            return fs.statSync(conf).isFile();
        }
        catch (err) {
            return false;
        }
    };
    // Checks whether or not the current folder has a GitHub remote
    TravisStatusIndicator.prototype.getUserRepo = function () {
        if (!vscode_1.workspace || !vscode_1.workspace.rootPath)
            return null;
        var fSettings = this.getUserRepoFromSettings();
        var fTravis = this.getUserRepoFromTravis();
        // Quick sanity check
        var user = (fSettings && fSettings.length > 0 && fSettings[0]) ? fSettings[0] : fTravis[0];
        var repo = (fSettings && fSettings.length > 1 && fSettings[1]) ? fSettings[1] : fTravis[1];
        return [user, repo];
    };
    // Setup status bar item to display that this plugin is in trouble
    TravisStatusIndicator.prototype.displayError = function (err, identifier) {
        this.setupStatusBarItem(err, 'stop', identifier);
    };
    // Setup status bar item to display that the build has passed;
    TravisStatusIndicator.prototype.displaySuccess = function (text, identifier) {
        this.setupStatusBarItem(text, 'check', identifier);
    };
    // Setup status bar item to display that the build has failed;
    TravisStatusIndicator.prototype.displayFailure = function (text, identifier) {
        this.setupStatusBarItem(text, 'x', identifier);
    };
    // Setup status bar item to display that the build is running;
    TravisStatusIndicator.prototype.displayRunning = function (text, identifier) {
        this.setupStatusBarItem(text, 'clock', identifier);
    };
    // Setup StatusBarItem with an icon and a tooltip
    TravisStatusIndicator.prototype.setupStatusBarItem = function (tooltip, icon, identifier) {
        if (!this._statusBarItem) {
            this._statusBarItem = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Left);
        }
        this._statusBarItem.text = identifier ? "Travis CI " + identifier + " $(" + icon + ")" : "Travis CI $(" + icon + ")";
        this._statusBarItem.tooltip = tooltip;
        this._statusBarItem.show();
    };
    // Get the username/repository combo from .vscode/settings.json
    TravisStatusIndicator.prototype.getUserRepoFromSettings = function () {
        if (!vscode_1.workspace || !vscode_1.workspace.rootPath)
            return null;
        var settingsFile = path.join(vscode_1.workspace.rootPath, '.vscode', 'settings.json');
        try {
            var settings = JSON.parse(fs.readFileSync(settingsFile, 'utf8'));
            if (settings) {
                var repo = settings['travis.repository'];
                var user = settings['travis.username'];
                return [user, repo];
            }
            else {
                return ['', ''];
            }
        }
        catch (e) {
            return ['', ''];
        }
    };
    // Get the username/repository combo from .travis.yml
    TravisStatusIndicator.prototype.getUserRepoFromTravis = function () {
        var ini = require('ini');
        var configFile = path.join(vscode_1.workspace.rootPath, '.git', 'config');
        try {
            var config = ini.parse(fs.readFileSync(configFile, 'utf-8'));
            var origin = config['remote "origin"'];
            if (origin && origin.url) {
                // Parse URL, get GitHub username
                var repo = origin.url.replace(/^(.*\/\/)?[^\/:]+[\/:]/, '');
                var combo = repo;
                if (repo.substr(repo.length - 4) === '.git') {
                    combo = repo.substr(0, repo.length - 4);
                }
                var split = combo.split('/');
                return (split && split.length > 1) ? split : ['', ''];
            }
        }
        catch (err) {
            return ['', ''];
        }
    };
    // Updates the configuration if it changes
    TravisStatusIndicator.prototype.updateStatusPollingConfiguration = function () {
        // Get the status polling settings
        var statusPolling = vscode_1.workspace.getConfiguration('travis').get('statusPolling');
        var statusPollingInterval = vscode_1.workspace.getConfiguration('travis').get('statusPollingInterval');
        // If the status polling settings have changed, clear the current setTimeout
        if (statusPolling !== this._statusPolling || statusPollingInterval !== this._statusPollingInterval) {
            clearTimeout(this._statusPollingTimeout);
            // Remember the new values
            this._statusPolling = statusPolling;
            this._statusPollingInterval = statusPollingInterval;
            // If still set to poll, start again now
            if (statusPolling === true) {
                this.updateStatus();
            }
        }
    };
    TravisStatusIndicator.prototype.getTravis = function () {
        if (this._travis == null) {
            this._travis = new Travis({
                version: '2.0.0',
                pro: vscode_1.workspace.getConfiguration('travis')['pro']
            });
        }
        // Make sure that we have github token or basic credentials
        if (vscode_1.workspace.getConfiguration('travis')['github_oauth_token'] != "") {
            this._travis.authenticate({
                github_token: vscode_1.workspace.getConfiguration('travis')['github_oauth_token']
            }, function (err) {
                // we've authenticated!
            });
        }
        else if (vscode_1.workspace.getConfiguration('travis')['github_user'] != "" && vscode_1.workspace.getConfiguration('travis')['github_password'] != "") {
            this._travis.authenticate({
                username: vscode_1.workspace.getConfiguration('travis')['github_user'],
                password: vscode_1.workspace.getConfiguration('travis')['github_password']
            }, function (err) {
                //we've authenticated!
            });
        }
        return this._travis;
    };
    TravisStatusIndicator.prototype.dispose = function () {
        this._statusBarItem.dispose();
    };
    return TravisStatusIndicator;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = TravisStatusIndicator;
//# sourceMappingURL=travis-status.js.map