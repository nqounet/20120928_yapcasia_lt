#!/usr/bin/env perl
use utf8;
use Mojolicious::Lite;
use Mojo::ByteStream qw(b);

app->secret( b(__FILE__)->md5_sum )
# ->log->debug(app->secret)
;

get '/' => sub {
  shift->render(
    template => 'presentation',
    presentation => <<'end_of_presentation',
\hYAPC::Asia 2012\nLightning Talks Day 1
ニフティクラウドC4SA\nを使ってみた
\h自己紹介
Twitter\n\n@nqounet
\h今日の発表
ニフティクラウドC4SA\nを使ってみた
\h質問です
ニフティクラウドC4SA\n（PaaS）をご存知の方？
\hもう一つ\n質問です
黒い画面\n（CLI）が\n苦手な方？
PaaSというと\nCLIなイメージ\nですよね？
ご安心ください！
ニフティクラウドC4SA\nはGUIです！
CLIが苦手でも
Vimが\n使えなくても
Emacsが\n使えなくても
大丈夫です！！！
\hDemo
黒い画面が\n好きな方に\nお知らせ
標準では\n使えるコマンドが\n少ない
ですが
大丈夫です！！！
$ env bash
bashが使えます！
\hまとめ
GUIのPaaSも便利
\h宣伝
MA8に向けて
ハッカソン\nやります！
\cMA8ハッカソン\nhttp://www.zusaar.com/event/405003
\hご清聴\nありがとう\nございました
end_of_presentation
  );
};

app->start;

__DATA__
@@ presentation.html.ep
% layout 'default', title 'ニフティクラウドC4SAを使ったら、デザイナーとの共同作業が楽になった！';
<header class="caption">
  <h1><%= title %></h1>
</header>
% my @slides = split /\n/, $presentation;
% my $slide_id = 0;
% for my $slide (@slides) {
  % my $shout = ' shout';
  % $slide =~ s!\\n!<br />!msg;
  % if ($slide =~ m!\A\\i(.*)\z!ms) { $slide = qq{<img src="$1" />} }
  % if ($slide =~ s!\\s!!ms or $slide =~ m!\\c!ms) { $shout = '' }
<div class="slide<%= $shout %>" id="<%= sprintf "No%03d", $slide_id++ %>"><div>
  <section>
  % if ($slide =~ s!\\h!!ms) {
    <header>
      <h2><%== $slide %></h2>
    </header>
  % }
  % elsif ($slide =~ s!\\c!!ms) {
    % my @lines = split m!<br />!, $slide;
    <h2><%= shift @lines %></h2>
    <pre>
    % for my $line ( @lines ) {
      %  if ($line =~ s!\\m!!ms) {
          <code><mark><%= $line %></mark></code>
      %  }
      %  else {
          <code><%= $line %></code>
      %  }
    % }
    </pre>
  % }
  % else {
    <h2><%== $slide %></h2>
  % }
  </section>
</div></div>
% }

@@ layouts/default.html.ep
<!DOCTYPE html>
<html lang="ja-JP">
<head>
  <meta charset="<%= app->renderer->encoding %>">
  <title><%= title %></title>
	<meta name="viewport" content="width=1274, user-scalable=no">
  <%= stylesheet '/shower/themes/ribbon/styles/style.css' %>
  <%= stylesheet '/css/app.css' %>
</head>
<body class="list" id="shower">
  <%= content %>
  <div class="progress"><div></div></div>
  <%= javascript '/js/jquery.js' %>
  <%= javascript '/shower/scripts/script.js' %>
</body>
</html>
