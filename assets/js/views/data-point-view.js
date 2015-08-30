window.DataPointView = function (container) {
	function renderDataPointElement (dataPoint) {
		var element = $("<div class='data-point' />");

		var titleElement = $("<h3 />");
		titleElement.text(scope.name);
		element.append(titleElement);

		if (scope.scopes.length > 0) {
			element.append(renderScopesElement(scope.scopes));
		}

		if (Object.keys(scope.dataPoints).length > 0) {
			var dataPointView = new DataPointView(element);
		}

		return element;
	};

	function renderDataPointsElement (dataPoints) {
		var element = $("<div class='data-points' />");

		for (var i = 0; i < dataPoints.length; i++) {
			element.append(renderScopeElement(scopes[i]));
		}

		return element;
	};

	function renderDataGroupsElement (dataGroups) {
		var element = $("<div class='data-groups' />");

		for (var key in dataGroups) {
			var renderedElement = renderDataGroupsElement(dataGroups[key]);
			element.append(renderedElement);
		}

		return element;
	};

	return {
		render: function (dataGroups) {
			container.empty();
			renderedElement = renderDataGroupsElement(dataGroups);
			container.append(renderedElement);
		}
	}
};