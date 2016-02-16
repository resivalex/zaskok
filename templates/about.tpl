<div class="about-container">
	<div class="fact-container">
		{foreach $facts as $fact}
			<div class="fact">
				<div class="image {$fact.image_class}"></div>
				<div class="text">
					<h3>{$fact.title}</h3>
					<ul>
					{foreach $fact.lines as $line}
						<li>{$line}</li>
					{/foreach}
					</ul>
				</div>
			</div>
		{/foreach}
	</div>

	<div class="youtube fade-out">
		<div class="player">
			<iframe src="https://www.youtube.com/embed/dzsJaPDiUR8" frameborder="0" allowfullscreen></iframe>
		</div>
	</div>
</div>