const path = require('path');

module.exports = {
    experiments: {
        futureDefaults: true
    },

    entry: {
        play: './src/play.bs.js',
        home: './src/home.bs.js'
    },
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, 'app/public/javascripts'),
        libraryTarget: 'var',
        library: 'App',
        hashFunction: 'xxhash64'
    },

    mode: "development",

    devServer: {
        static: {
            contentBase: path.join(__dirname, "app/dist")
        },
        port: 9000
    }
};
