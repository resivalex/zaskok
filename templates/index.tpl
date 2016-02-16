{extends file="layout.tpl"}
{block name=title}ZAскок — Батутный центр{/block}
{block name=head_includes}
	<link rel="stylesheet" type="text/css" href="css/landing.css">
	<link type="text/css" rel="stylesheet" href="light-gallery/css/lightgallery.css" />
{/block}
{block name=body_includes}
	<!-- lightgallery plugins -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/lightgallery/1.2.14/js/lg-thumbnail.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/lightgallery/1.2.14/js/lg-fullscreen.min.js"></script>
	<script src="js/order.js"></script>
{/block}
{block name=body}
<div class="under-nav"></div>
	<nav>
		<ul>
			<li>
				<a class="menu-logo">&nbsp;</a>
			</li>
			{foreach $sections as $section}
				<li>
					<a href="#{$section.id}">{$section.title}</a>
				</li>
			{/foreach}
		</ul>
	</nav>
	<header>
		{include file='header.tpl'}
	</header>
	{foreach $sections as $section}
		<section id="{$section.id}" class="card">
			<h2>{$section.title}</h2>
			{include file={$section.file} }
		</section>
	{/foreach}
	
	{include 'footer.tpl'}
{/block}