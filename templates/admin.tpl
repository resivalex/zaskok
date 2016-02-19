{extends file="layout.tpl"}
{block name=title}Журнал{/block}
{block name=head_includes}
	<link rel="stylesheet" type="text/css" href="css/log.css">
{/block}
{block name=body_includes}
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.0/angular.min.js"></script>
	<script src="js/log.js"></script>
{/block}
{block name=body}
{if $is_admin}
	{include file='log.tpl'}
{else}
	{include file='login-form.tpl'}
{/if}
{/block}