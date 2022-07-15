# Yeoman and VSCode

You learned a lot this week, and you want to get ready to make your own eXist-db app. During this code-along session, we'll learn two tools that help you do this.

## Yeoman 

[Instructions for initializing a new repo](https://github.com/Pittsburgh-NEH-Institute/pr-app/blob/main/pr-app-tutorials/yeoman.md)

Overview:
1. generate your eXist app
2. build and install the app
3. change the branch name to main `git branch -m main`
4. use “push an existing repository” in Github

## Using VSCode

VSCode, or Visual Studio Code, is an integrated development environment (IDE) made by Microsoft. It is a popular development tool for its wide array of features, and it's free to use. We want to use it for two reasons:

1. There is a free extension (like an app in an app store) that allows syncing with the eXist-db server. This means you can open and edit files on your file system and the changes you make will sync to the app on the server. You don't have to rebuild every time you make a change on the file system!
2. Why do you care about that? You can't really use Git to track your changes on the server itself, so it's helpful to manage your changes in both places at once: the server, where you execute the code, and the file system, where you track changes and pull updates from colleagues.

### Set up syncing

0. You already added your app from above to the database, and it's still running, so you don't need to do anything else from the eXist side.
1. Open VSCode.
2. If you have not already done so, please install the [existdb-vscode extension](https://marketplace.visualstudio.com/items?itemName=eXist-db.existdb-vscode) from the marketplace.
3. Under "File" click "Add Folder to Workspace". Select the root directory for the app you initialized in the yeoman.md instructions.
4. Under “File” select “Save workspace as” and give your workspace a meaningful name, saving into the root directory of the app.
5. Open the workspace.
6. Create and save a file called .existdb.json and paste in the following.
```
{
  "servers": {
    "localhost": {
      "server": "http://localhost:8080/exist",
      "user": "admin",
      "password": "",
      "root": "/db/apps/name-of-your-app"
    }
  },
  "sync": {
    "server": "localhost",
    "active": true,
    "ignore": [
      ".existdb.json",
      ".git/**",
      ".github/**",
      "node_modules/**",
      "build/**",
      ".vscode/**",
      "README.md",
      "yo-rc.json",
      "*.code-workspace"
    ]
  }
}
```

7. Under "Terminal" select "Run Task" and then begin typing "exist-db". There should be a task called "exist-db:sync-your-workspace-name". When you run it, a terminal panel will open inside vscode.
8. To test your connection, in the workspace create a new XML file that consists entirely of <code>Hello world!</code> and save inside your rep with the filetype .xml.
9. To confirm that sync is working do any of the following:
- Watch the terminal panel.
- Open the app in your browser (if the app is configured to show available files).
- Launch the eXist-db Java Admin Client and look for your new file there.

### Ready to move on?

Try creating data/ views/ and modules/ collections for your own edition.

Try writing some XQuery and using CMD + Shift + Enter (Mac) or CTRL + Shift + Enter (Windows) to execute that code.

Try copying the controller from pr-app to see if you can get the views and modules to work together.

