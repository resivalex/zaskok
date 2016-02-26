<div class="gallery">
  {foreach $slides as $slide}
    <a href="{$slide}">
      {* <div class="thumb-container"> *}
        <img class="rand-popup thumb" src="{$thumbs[$slide@iteration - 1]}" />
      {* </div> *}
    </a>
  {/foreach}
</div>