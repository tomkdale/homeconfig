'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
class Pomodoro {
    constructor(context) {
        this.second = 1000;
        this.minOrSec = 60;
        this.work = 25;
        this.break = 5;
        this.longBreak = 30;
        this.currentTime = this.work * this.second * this.minOrSec;
        this.repeat = 4;
        this.tasksLeft = this.repeat;
        this.autoStart = false;
        this.set = 1;
        this.task = 1;
        this.is = 'reset';
        this.nextIs = 'start';
        this.active = '';
        this.currentHour = '00';
        this.currentMinute = '00';
        this.currentSecond = '00';
        this.texts = { statusbar: '', notification: '', tooltip: '' };
        this.vsCodeStatusBar = { command: '', show: () => { }, dispose: () => { }, hide: () => { }, text: '', tooltip: '' };
        this.make = { statusbar: { priority: 1000, alignment: 'right' }, notification: true };
        this.file = null;
        this.setInterval = null;
        this.context = context;
        this.stateGetConf();
        this.stateGet();
        this.setup();
        if (this.autoStart && this.is === 'reset')
            this.startPause();
        else if (this.is === 'started')
            this.tick();
    }
    startPause() {
        if (this.nextIs === 'pause') {
            clearInterval(this.setInterval);
            this.setInterval = null;
            this.is = 'paused';
            this.nextIs = 'resume';
            this.textNotification();
            this.textStatusBar();
            this.textTooltip();
            this.sendToFile();
            this.stateUpdate();
        }
        else if (this.nextIs === 'resume') {
            this.is = 'started';
            this.nextIs = 'pause';
            this.textNotification();
            this.textStatusBar();
            this.textTooltip();
            this.sendToFile();
            this.tick();
        }
        else {
            this.is = 'started';
            this.nextIs = 'pause';
            this.active = 'work';
            this.HMS();
            this.textNotification();
            this.textStatusBar();
            this.textTooltip();
            this.sendToFile();
            this.tick();
        }
    }
    reset() {
        clearInterval(this.setInterval);
        this.setInterval = null;
        this.set = 1;
        this.task = 1;
        this.tasksLeft = this.repeat;
        this.is = 'reset';
        this.nextIs = 'start';
        this.active = '';
        this.currentTime = this.work * this.second * this.minOrSec;
        this.HMS();
        this.textNotification();
        this.textStatusBar();
        this.textTooltip();
        this.vsCodeStatusBar.show();
        this.sendToFile();
        this.stateUpdate();
    }
    setup() {
        const config = vscode.workspace.getConfiguration('pomodoro');
        this.file = config.filePath && this.preRequire(config.filePath, () => vscode.window.showWarningMessage('Pomodoro error. Check the file path in `pomodoro.filePath` setting.')) ? require(config.filePath) : null;
        let updateTime = false;
        const newMinOrSec = config.interval === 'seconds' ? 1 : 60;
        if (newMinOrSec !== this.minOrSec) {
            updateTime = true;
            this.minOrSec = newMinOrSec;
        }
        if (this.work !== config.work) {
            updateTime = true;
            this.work = config.work;
        }
        if (this.break !== config.break) {
            updateTime = true;
            this.break = config.break;
        }
        if (this.longBreak !== config.longBreak) {
            updateTime = true;
            this.longBreak = config.longBreak;
        }
        let updateStateConf = false;
        if (updateTime) {
            this.currentTime = this.work * this.second * this.minOrSec;
            updateStateConf = true;
        }
        if (this.repeat !== config.repeat) {
            this.repeat = this.tasksLeft = config.repeat;
            this.task = 1;
            updateStateConf = true;
        }
        if (updateStateConf)
            this.stateUpdateConf();
        this.texts = config.texts;
        this.make = config.make;
        if (this.make.statusbar) {
            if (this.vsCodeStatusBar.command) {
                this.vsCodeStatusBar.hide();
                this.vsCodeStatusBar.dispose();
            }
            this.vsCodeStatusBar = vscode.window.createStatusBarItem(vscode.StatusBarAlignment[this.make.statusbar.alignment === 'left' ? 'Left' : 'Right'], this.make.statusbar.priority);
            this.vsCodeStatusBar.command = 'extension.pomodoroStartPause';
            this.HMS();
            this.textStatusBar();
            this.textTooltip();
            this.vsCodeStatusBar.show();
        }
        this.autoStart = config.autoStart;
    }
    tick() {
        this.setInterval = setInterval(() => {
            this.currentTime -= this.second;
            this.HMS();
            if (this.currentTime <= 0) {
                if (this.active === 'longBreak') {
                    this.active = 'work';
                    this.set++;
                    this.task = 1;
                    this.tasksLeft = this.repeat;
                    this.currentTime = this.work * this.second * this.minOrSec;
                }
                else if (this.active === 'break') {
                    this.active = 'work';
                    this.task++;
                    this.tasksLeft--;
                    this.currentTime = this.work * this.second * this.minOrSec;
                }
                else {
                    if (this.task < this.repeat) {
                        this.active = 'break';
                        this.currentTime = this.break * this.second * this.minOrSec;
                    }
                    else {
                        this.active = 'longBreak';
                        this.currentTime = this.longBreak * this.second * this.minOrSec;
                    }
                }
                this.textNotification();
                this.sendToFile();
            }
            this.textStatusBar();
            this.stateUpdate();
        }, this.second);
    }
    textStatusBar() {
        if (!this.make.statusbar)
            return;
        this.vsCodeStatusBar.text = this.reg(this.texts.statusbar);
    }
    textTooltip() {
        if (!this.make.statusbar)
            return;
        this.vsCodeStatusBar.tooltip = this.reg(this.texts.tooltip);
    }
    textNotification() {
        if (!this.make.notification)
            return;
        vscode.window.showInformationMessage(this.reg(this.texts.notification));
    }
    reg(text) {
        return text
            .replace(/%work{(.*?)}|%break{(.*?)}|%longBreak{(.*?)}/gm, this.active === 'work'
            ? '$1'
            : this.active === 'break'
                ? '$2'
                : this.active === 'longBreak'
                    ? '$3'
                    : '')
            .replace(/%started{(.*?)}|%paused{(.*?)}|%reset{(.*?)}/gm, this.is === 'started'
            ? '$1'
            : this.is === 'paused'
                ? '$2'
                : this.is === 'reset'
                    ? '$3'
                    : '')
            .replace(/%repeat/gm, String(this.repeat))
            .replace(/%tasksLeft/gm, String(this.tasksLeft))
            .replace(/%task/gm, String(this.task))
            .replace(/%set/gm, String(this.set))
            .replace(/%hour/gm, this.currentHour)
            .replace(/%minute/gm, this.currentMinute)
            .replace(/%second/gm, this.currentSecond);
    }
    sendToFile() {
        if (!this.file)
            return;
        this.file({
            repeat: this.repeat,
            task: this.task,
            set: this.set,
            is: this.is,
            active: this.active
        });
    }
    HMS() {
        let seconds = this.currentTime / this.second;
        const hours = Math.trunc(seconds / 3600) % 24;
        seconds = seconds % 3600;
        const minutes = Math.trunc(seconds / 60);
        seconds = seconds % 60;
        this.currentHour = ('0' + String(hours)).slice(-2);
        this.currentMinute = ('0' + String(minutes)).slice(-2);
        this.currentSecond = ('0' + String(seconds)).slice(-2);
    }
    stateUpdate() {
        this.context.globalState.update('pomodoroState', {
            is: this.is,
            task: this.task,
            set: this.set,
            tasksLeft: this.tasksLeft,
            nextIs: this.nextIs,
            active: this.active,
            currentTime: this.currentTime
        });
    }
    stateGet() {
        const state = this.context.globalState.get('pomodoroState', {
            is: this.is,
            task: this.task,
            set: this.set,
            tasksLeft: this.tasksLeft,
            nextIs: this.nextIs,
            active: this.active,
            currentTime: this.work * this.second * this.minOrSec
        });
        this.is = state.is;
        this.task = state.task;
        this.set = state.set;
        this.tasksLeft = state.tasksLeft;
        this.nextIs = state.nextIs;
        this.active = state.active;
        this.currentTime = state.currentTime;
    }
    stateUpdateConf() {
        this.context.globalState.update('pomodoroConf', {
            repeat: this.repeat,
            minOrSec: this.minOrSec,
            work: this.work,
            break: this.break,
            longBreak: this.longBreak,
        });
    }
    stateGetConf() {
        const pomodoroConf = this.context.globalState.get('pomodoroConf', {
            repeat: this.repeat,
            minOrSec: this.minOrSec,
            work: this.work,
            break: this.break,
            longBreak: this.longBreak,
        });
        this.repeat = pomodoroConf.repeat;
        this.minOrSec = pomodoroConf.minOrSec;
        this.work = pomodoroConf.work;
        this.break = pomodoroConf.break;
        this.longBreak = pomodoroConf.longBreak;
    }
    preRequire(path = '', onNotFound = () => { }) {
        try {
            require.resolve(path);
        }
        catch (e) {
            onNotFound();
            return false;
        }
        return true;
    }
}
exports.Pomodoro = Pomodoro;
//# sourceMappingURL=pomodoro.js.map