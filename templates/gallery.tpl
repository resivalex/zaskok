<div class="gallery">
  {foreach $slides as $slide}
    <a href="{$slide}"><img class="rand-popup thumb" src="{$thumbs[$slide@iteration - 1]}" /></a>
  {/foreach}
</div>