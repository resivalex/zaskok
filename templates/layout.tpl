<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	{block name=head_includes}{/block}
	<title>{block name=title}Default title{/block}</title>
</head>
<body>
	<!-- EcmaScript5 support for old browsers -->
	<script type="text/javascript" src="js/lib/es5-sham.min.js"></script>
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
	<!-- jQuery UI -->
	<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
	<!-- Waypoints. For scrolling control. -->
	<script type="text/javascript" src="js/lib/jquery.waypoints.min.js"></script>
	<!-- Animation TweenMax -->
	<script src="js/lib/tween-max.min.js"></script>
	<!-- Landing interactions -->
	<script type="text/javascript" src="js/landing.js"></script>
	<!-- jQuery version must be >= 1.8.0; -->
	<script src="light-gallery/js/lightgallery.min.js"></script>
	<!-- A jQuery plugin that adds cross-browser mouse wheel support. (Optional) -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
	<!-- AngularJS -->
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.0/angular.min.js"></script>
	<!-- My AngularJS modules -->
	<script src="/js/modules.js"></script>
	{block name=body_includes}{/block}

{* 	<!-- LiveReload -->
	<script>document.write('<script src="http://' + (location.host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1"></' + 'script>')</script>
 *}
	{block name=body}{/block}

</body>
</html>