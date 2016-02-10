<footer>
	<div class="partners">
		<div class="container">
			{foreach $partners as $partner}
				<a href="{$partner.url}">
					<div class="a">
						<img src="{$partner.img}">
						<div class="title">
							<span>{$partner.title}</span>
						</div>
					</div>
				</a>
			{/foreach}
		</div>
	</div>

	<div class="copy">
		Все права защищены &copy; Air Plaza 2015-{date('Y')}
	</div>  
</footer>
