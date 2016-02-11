<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
  <link rel="stylesheet" type="text/css" href="css/landing.css">
  <link type="text/css" rel="stylesheet" href="light-gallery/css/lightgallery.css" /> 
  <title>ZAскок - Батутный центр</title>
</head>
<body>

  <!-- EcmaScript5 support for old browsers -->
  <script type="text/javascript" src="js/lib/es5-sham.min.js"></script>
  <!-- jQuery -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
  <!-- Подключаем API карт -->
  <script src="http://api-maps.yandex.ru/2.1/?load=package.map,package.search&lang=ru-RU" type="text/javascript"></script>
  <!-- jQuery UI -->
  <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
  <!-- Waypoints. For scrolling control. -->
  <script type="text/javascript" src="js/lib/jquery.waypoints.min.js"></script>
  <!-- Animation TweenMax -->
  <script src="js/lib/tween-max.min.js"></script>
  <!-- AirPlaza on Yandex.Map -->
  <script type="text/javascript" src="js/map.js" charset="utf-8"></script>
  <!-- Landing interactions -->
  <script type="text/javascript" src="js/landing.js"></script>
  <!-- jQuery version must be >= 1.8.0; -->
  <script src="light-gallery/js/lightgallery.min.js"></script>
  <!-- A jQuery plugin that adds cross-browser mouse wheel support. (Optional) -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
  <!-- lightgallery plugins -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/lightgallery/1.2.14/js/lg-thumbnail.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/lightgallery/1.2.14/js/lg-fullscreen.min.js"></script>

  <!-- LiveReload -->
  <script>document.write('<script src="http://' + (location.host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1"></' + 'script>')</script>

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
      {* First section hasn't header *}
      {* {if $section@iteration != 1} *}
        <h2>{$section.title}</h2>
      {* {/if} *}
      {include file={$section.file} }
    </section>
  {/foreach}
  
  {include 'footer.tpl'}

</body>
</html>