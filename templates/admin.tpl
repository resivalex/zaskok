{extends file="layout.tpl"}
{block name=title}Журнал{/block}
{block name=head_includes}
	<link rel="stylesheet" type="text/css" href="css/admin.css">
{/block}
{block name=body_includes}
	<script src="js/admin.js"></script>
{/block}
{block name=body}
{if $isAdmin}
	{include file='log.tpl'}
{else}
	{include file='login-form.tpl'}
{/if}
{/block}