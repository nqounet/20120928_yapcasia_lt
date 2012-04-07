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
Mojolicious::Lite\n\nでPJAXしてみた
その前に
\hKyoto.pm\n\n設立
\hおめでとう\n\nございます！

\h自己紹介
名前\n\n若林 信敬
Twitter\n\n@nqounet
\i/images/twitter_profile.jpg
Facebook\n\nやってます
\i/images/facebook_profile.png
職業\nフリー\nエンジニア
IT Office 西宮原
\i/images/iton.png
Perlの仕事\nください
今日の発表
の前に
皆さん
use strict;\n\nしてますか？
という事で
Perl入学式を\nよろしく\nお願いします

\h今日の発表
Mojolicious::Lite\n\nでPJAXしてみた
\hPJAXとは\n何か？
簡単に言うと
AJAXの\n\n問題点を
克服した
次世代型\n\n非同期通信
\hAJAXの\n\n問題点
\hその１
ブラウザの
戻るボタンで
戻れない
（字余り）
\hその２
JavaScript\n\nオフ
orz
AJAXの
「J」は
JavaScriptの
\h「J」
出来なくても
仕方ない！
（困ります）
\h大丈夫
ご安心ください
PJAXが
それらの問題点の
すべてを
解決いたします！

\hPJAX
jQueryの\n\nプラグイン
jquery-pjax
\h超便利
\hDEMO
\hPJAXとは\n\n何か？
pushState\n+\nAJAX
\hPJAXの\n仕組み
\hその１
\hブラウザの\n戻る／進む\nが使える
pushState
ブラウザの履歴を\n\n追加できる
\chistory.pushState(data, title [, url])
\hその２
\hクローラに\nやさしい\n固定リンク
綺麗なURLで
しかも
JavaScript\n\nオフ
\hOK
つまり
wget
\hOK
そして
curl
\hOK
AJAXの問題点が
\h全て解決
何度も言いますが
PJAXとは
\h次世代型\n\n非同期通信

\h実装
Mojolicious::Lite\n&amp;\njquery-pjax
\hポイント
jquery-pjaxは
PJAXでの\nリクエスト時
HTTPヘッダに
&quot;X-PJAX: true&quot;
送信
Mojolicious::Lite
このヘッダを\n読み取って
真の場合は
PJAX用の\n\nlayout
偽の場合は
通常の\n\nlayout
この分岐を\n\n全てのルート上に
作成
どうするか？
\h一つの解
\hunder
最初に定義する
\croot/app.pl\nunder sub {\n  my $self = shift;\n  $self->layout(\n    $self->req->headers->header('X-PJAX')\n      ? 'pjax' : 'default'\n  );\n  1;\n};
全てのルートが
ここを通る
次にlayoutを作成
\croot/template/layouts/default.html.ep\n<html>\n  <head><title><%= title %></title></head>\n  <body>\n    <div id="pjaxbody"><%= content %></div>\n    <%= javascript '/js/jquery.js' %>\n    <%= javascript '/js/app.js' %>\n  </body>\n</html>
id付のdivで囲む
あとは
jQueryで
\croot/public/js/app.js\njQuery( function($) {\n  $("a.pjaxlink").pjax('#pjaxbody');\n});
PJAXにしたい\n\nリンクに
バインドさせる
この場合は
PJAXにしたいリンクを
class="pjaxlink"
とすれば
OK
\cMojolicious::Lite & jquery-pjax\nhttps://github.com/nqounet/p5-mojo-pjax
まとめ
\hPJAX
\h次世代型\n\n非同期通信
\h質問
ご清聴\nありがとう\nございました
&nbsp;
end_of_presentation
  );
};

app->start;

__DATA__
@@ presentation.html.ep
% layout 'default', title 'Mojolicious::LiteでPJAXしてみた';
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
