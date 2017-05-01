module.exports = function(grunt) {
	grunt.loadNpmTasks("grunt-contrib-qunit");
	grunt.loadNpmTasks("grunt-contrib-watch");
	grunt.loadNpmTasks("grunt-contrib-jshint");

	grunt.initConfig({

		pkg: grunt.file.readJSON('package.json'),

		qunit: {
			all: "tests.html"
		},

		jshint: {
			files: ['change.js', 'tests.js'],
			options: {
				globals: {
					jQuery: true,
					esversion: 6
				}
			}
		},

		watch: {
			scripts: {
				files: 'tests.js', tasks: ['jshint', 'qunit']
			}
		}

	});

	grunt.registerTask('default', ['jshint', 'qunit']);
};