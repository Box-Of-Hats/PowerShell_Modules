
#region files

$GIT_IGNORE = '/node_modules/
';

$TASKS_JSON = '{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "webpack: watch",
            "type": "shell",
            "command": "webpack --watch"
        },
        {
            "label": "webpack: build",
            "type": "shell",
            "command": "webpack"
        }
    ]
}
';

$INDEX_JS = 'import React from "react";
import ReactDOM from "react-dom";
import { App } from "./App.jsx";

ReactDOM.render(<App />, document.querySelector("#app"));
';

$APP_JSX = 'import React from "react";
import "./app.scss";

export const App = props => {
    return <h1>Hello world</h1>;
};

';

$INDEX_HTML = '<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <title>Template Project | Home</title>
    </head>
    <body>
        <div id="app"></div>

        <script src="/dist/bundle.js"></script>
    </body>
</html>
';

$APP_SCSS = 'h1 {
    font-style: italic;
}
'
$WEBPACK_CONFIG = '"use strict";

const path = require("path");

module.exports = {
    entry: "./src/index.js",
    context: path.resolve(__dirname),
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "bundle.js",
        publicPath: "/"
    },
    module: {
        rules: [
            {
                test: /\.(js|jsx)$/,
                exclude: /node_modules/,
                use: {
                    loader: "babel-loader"
                }
            },
            {
                test: /\.scss$/i,
                use: ["style-loader", "css-loader", "sass-loader"]
            }
        ]
    },
    mode: "development",
    resolve: {},
    devtool: "source-map",
    plugins: []
};
';

$BABEL_RC = '{
    "presets": ["@babel/preset-env", "@babel/preset-react"]
}
';

#endregion

function New-ReactProject {
    Param(
        [Parameter(Mandatory = $true)][string]$ProjectName
    )

    # project directory
    $projectDirectory = New-Item -Path $ProjectName -ItemType Directory
    Set-Location $projectDirectory

    # npm packages
    npm init -y

    # dependencies
    npm i react react-dom

    # dev dependencies
    npm i @babel/core @babel/preset-env @babel/preset-react babel-loader webpack sass-loader node-sass css-loader style-loader --save-dev

    # config files
    New-Item -Path "./webpack.config.js" -ItemType File -Value $WEBPACK_CONFIG
    New-Item -Path "./.babelrc" -ItemType File -Value $BABEL_RC

    # .vscode
    $vsCodeDirectory = New-Item -Path "./.vscode" -ItemType Directory
    Set-Location $vsCodeDirectory
    New-Item -Path "./tasks.json" -ItemType File -Value $TASKS_JSON
    Set-Location ..

    # src directory
    $srcDirectory = New-Item -Path "./src" -ItemType Directory
    Set-Location $srcDirectory
    New-Item -Path "./App.jsx" -ItemType File -Value $APP_JSX
    New-Item -Path "./app.scss" -ItemType File -Value $APP_SCSS
    New-Item -Path "./index.js" -ItemType File -Value $INDEX_JS
    Set-Location ..

    # dist directory
    $distDirectory = New-Item -Path "./dist" -ItemType Directory
    Set-Location $distDirectory
    New-Item -Path "./index.html" -ItemType File -Value $INDEX_HTML
    Set-Location ..

    # git
    New-Item -Path "./.gitignore" -ItemType File -Value $GIT_IGNORE
    git init
    git add .
    git commit -m "initial commit"

    # done
    Write-Host "`n" -BackgroundColor Green
    Write-Host ""
    Write-Host "All done!" -ForegroundColor Green
    Write-Host "1. open vscode here" -ForegroundColor Green
    Write-Host "2. webpack: build (optionally webpack: watch)" -ForegroundColor Green
    Write-Host "3. open index.html with live server" -ForegroundColor Green
    Write-Host "`n" -BackgroundColor Green
    Write-Host ""

}


Export-ModuleMember New-ReactProject
