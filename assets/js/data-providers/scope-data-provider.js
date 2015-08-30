window.ScopeDataProvider = function (basePath) {
	return {
		getAll: function (callback) {
			$.get(basePath + "scopes/", callback);
		}
	};
};