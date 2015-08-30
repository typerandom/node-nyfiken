window.ScopeView = function (container) {
	function renderScopeElement (scope) {
		var element = $("<div class='scope' />");

		var titleElement = $("<h3 />");
		titleElement.text(scope.name);
		element.append(titleElement);

		if (scope.scopes.length > 0) {
			element.append(renderScopesElement(scope.scopes));
		}

		return element;
	};

	function renderScopesElement (scopes) {
		var element = $("<div class='scopes' />");

		for (var i = 0; i < scopes.length; i++) {
			element.append(renderScopeElement(scopes[i]));
		}

		return element;
	};

	return {
		render: function (scopes) {
			container.empty();
			renderedElement = renderScopesElement(scopes);
			container.append(renderedElement);
		}
	}
};