# Installing required software

## Synopsis

This page decribes how to install the software we will use during the Institute. Please install as any of the packages as you can
before you arrive, but should you run into any problems, we’ve allocated time on the first day of the Institute to ensure that
everyone’s installations are up to date.

## Instructions for MacOS users

### General installation guidelines

1. Because some of the packages below depend on other packages, you will need to install them in the specified order.
1. Except where we specify otherwise, install everything as a regular user (don’t use *sudo*—and don’t worry about what *sudo* is if you don’t already know).
1. When prompted to upgrade any of these packages except *node* (but including *npm* and *nvm*), accept the prompt.

### Install *homebrew*

*Homebrew* is a package manager for MacOS, that is, an application that helps you install other applications. Read [About Homebrew](https://brew.sh/) and install with:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install *eXist-db*

Install the current stable version from <http://exist-db.org/exist/apps/homepage/index.html>.

### Install *git*

Type `git` at the command line. If it isn’t installed, accept the prompt to install the Xcode command line tools (this installation may take a long time).

### Install *vscode* and the *existdb-vscode* module

1. Run `brew install --cask vscode` or install from <https://code.visualstudio.com>
1. For *existdb-vscode* do *one* of the following:
    * Open Virtual Studio Code, search for existdb-vscode module, and follow installation instructions
    * Install from <https://marketplace.visualstudio.com/items?itemName=eXist-db.existdb-vscode&utm_source=VSCode.pro&utm_campaign=AhmadAwais>
    * Install from <https://github.com/wolfgangmm/existdb-langserver>

### Install *npm* and *nvm*

1. Install *npm* (node package manager) with `brew install npm`
2. Install *nvm* (node version manager) with `brew install nvm`. (Why? *nvm* lets you install and choose among different *node* releases, and Yeoman requires node v. 14, which is not the most recent version.)
2. **Don’t skip this step!** Run `brew info nvm` and follow the “caveats” instructions.
2. Install *node* v. 14 with `nvm install 14`.
3. Activate *node* v. 14 with `nvm use 14`. (This command persists only in a single shell, which is what you want, but it means that you have to run again each time you launch a new shell.)

### Install *yeoman* for eXist-db

1. `npm i -g yo`
1. `npm i -g @existdb/generator-exist`

## Instructions for Windows users

### General installation guidelines

1. Unless otherwise specified, in order to install packages from the command line you should first launch Windows PowerShell or Git Bash as Administrator (this is an elevated command prompt).
1. Because some of the packages below depend on other packages, you will need to install them in the specified order.
1. Except where we specify otherwise, install everything as a regular user (don’t use *sudo*—and don’t worry about what *sudo* is if you don’t already know).
1. When prompted to upgrade any of these packages except *node* (but including *npm* and *nvm*), accept the prompt.

### Install *Chocolatey*

*Chocolatey* is a *package manager* for Windows, that is, an application that helps you install other applications.

1. Read Read [about Chocolatey](https://chocolatey.org/how-chocolatey-works) and [What is PowerShell?](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2) to learn about these two packages.
2. Verify that you have Windows PowerShell installed by searching for it through the Windows Start menu. If not, [install Windows PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2). 
2. Search for PowerShell through the Windows Start menu, right click on it, and select *Run as administrator*. Click *Yes* when asked whether you want to allow PowerShell to make changes to your device. 
3. Follow the [Chocolatey installation instructions](https://chocolatey.org/install#individual) for individual use.

### Install *eXist-db*

1. Install the current stable version of eXist-db from <http://exist-db.org/exist/apps/homepage/index.html> To do that follow the [installation instructions](https://exist-db.org/exist/apps/doc/basic-installation) on the eXist-db website. (**Important:** Pay attention to the instructions about Java versions. eXist-db requires Java 8 or Java 11.) If you are given the option of installing eXist-db “as a service”, decline that option.
2. You will know that the installation has been successful if, after following all prompts, the eXist-db launcher opens when you navigate to <http://localhost:8080/> in your browser. 
3. If you are having trouble getting eXist-db to run:
   - Uninstall eXist-db.
   - Make sure that you have [OpenJDK](https://www.openlogic.com/openjdk-downloads) installed. From this general download site select Java version 8, Windows operating system, x86 64-bit architecture, and JDK Java package.
   - Reinstall eXist-db and verify that it launches successfully. 
4. If eXist-db still will not run, follow their [troubleshooting instructions](https://exist-db.org/exist/apps/doc/troubleshooting) or [advanced installation guide](https://exist-db.org/exist/apps/doc/advanced-installation).

### Install *git*

Type `git` at the command line. If it isn't installed, type `choco install git`. This will also install Git Bash. From now on, instead of using PowerShell, you will use Git Bash as your command line interface. (**Important:** Remember to launch Git Bash as Administrator when installing anything. You can do that by navigating to Git Bash in the Windows Start menu, right clicking, and selecting *Run as administrator*.) 

### Install *vscode* + *existdb-vscode* module 

1. Check if vscode is already on your machine by typing `code --version` at the command line. 
2. If not, make sure Git Bash has been launched as administrator and then type `choco install vscode`.
3. Install *existdb-vscode* from <https://marketplace.visualstudio.com/items?itemName=eXist-db.existdb-vscode&utm_source=VSCode.pro&utm_campaign=AhmadAwais>.

### Install *npm* and *nvm*

1. Install *npm* (node package manager) with `choco install npm`.
2. Install *nvm* (node version manager) with `choco install nvm`. (Why? nvm lets you install and choose among different node releases, and Yeoman requires node v. 14, which is not the most recent version.)
3. **Important**: Restart Git Bash. 
4. Install *node* v.14 with `nvm install 14`. The installation will show you the full number of the version (for example, v14.19.1 instead of v14). **Write down the full version number and save it for future use**. 
5. Activate *node* v.14 with `nvm use 14.19.1` (or the full version number you saved from the previous step). (This command persists only in a single shell, which is what you want, but it means that you have to run it again each time you launch a new shell).

If at any point you have issues using *npm* or *nvm*, check your Program Files directory for a *nodejs* subdirectory and delete that directory. Instructions for this remedy are available at <https://github.com/coreybutler/nvm-windows/issues/191#issuecomment-233779673> in the solution given by the user “pleverett”.  

### Install *yeoman* for eXist-db

1. `npm i -g yo`
2. `npm i -g @existdb/generator-exist`