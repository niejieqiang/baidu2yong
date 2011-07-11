#!/usr/bin/perl -w
use strict;
use File::Find;
use Image::Size;
use File::Basename;
use DirHandle;
use Cwd;
use feature qw(say);

#将皮肤文件夹内的文件名存为数组。
my $dh= DirHandle->new($ARGV[0] ||".");
my @file_lists=$dh->read;
undef $dh;

&about_tray_module;
&main_module;
&input_module;

sub about_tray_module {
	my $skin_name=basename(getcwd);
	say "#输入法名字\n[about]";
	say "name=$skin_name";
	say "\n#托盘icon";
	say "[tray]";
	say "icon=tray1.ico,tray2.ico";
}

sub main_module { 
	say "\n#状态栏设置\n[main]";
	my $toolbar_bg=qr/toolbar_background\.png/;
	&print_background_and_size($toolbar_bg);
    my ($img_width,$img_height)=&get_imgsize(&find_image_name($toolbar_bg));
	say "move=1,1,".int($img_width/5).",$img_height";

	my $chinese=qr/chinese.*png/;
	my $english=qr/english.*png/;
	my $full=qr/full.*png/;
	my $half=qr/half.*png/;
	my $en_punctuation=qr/en_punctuation.*png/;
	my $cn_punctuation=qr/cn_punctuation.*png/;
	my $keyboard=qr/login.*png/;
	my $setting=qr/setting.*png/;
	my $x_toolbar=8;			# 最左边图标的x坐标
	my $y_toolbar=26;			#状态栏图标y坐标
	my $increament=15;			#增量---第一个图标和第二个图标之间x坐标的差值

	say "\n#中英文图标位置\nlang=$x_toolbar,$y_toolbar";
	say "lang_cn=",join ',',&get_sorted_png($chinese);
	say "lang_en=",join ',',&get_sorted_png($english);

	say "\n#全半角\ncorner=".($x_toolbar+$increament).",$y_toolbar";	
	say "corner_full=",join ',',&get_sorted_png($full);
	say "corner_half=",join ',',&get_sorted_png($half);
	
	say "\n#标点设置\nbiaodian=".($x_toolbar+2*$increament).",$y_toolbar";	
	say "biaodian_en=",join ',',&get_sorted_png($en_punctuation);
	say "biaodian_cn=",join ',',&get_sorted_png($cn_punctuation);

	say "\n#键盘小图片设置\nkeyboard=".($x_toolbar+3*$increament).",$y_toolbar";
	say "keyboard_img=",join ',',&get_sorted_png($keyboard);

	say "\n#菜单图片设置\nmenu=".($x_toolbar+4*$increament).",$y_toolbar";
	say "menu_img=",join ',', &get_sorted_png($setting);
}

sub input_module {
	my $main_background=qr/main_backgroundH\.png/;
	say "\n#候选窗设置\n[input]";
	&print_background_and_size($main_background);
	say "\n#图案防拉伸设置";
    my ($width,$height)=&get_imgsize(&find_image_name($main_background));
	say "stretch=".int($width/2).",".($width-$width/2-2);
	say "\n#文字左右出现位置\nwork=15,15";
	say "\n#编码出现位置\ncode=45,30";
	say "\n#候选词出现位置\ncand=45,52";
	say "space=10";
	say "font=Arial 12";
	say "\n#字体颜色";
	say "color=#929142,#BD5407,#929142,#929142";
	say "#0:两行,1:单行,2:多行";
	say "line=0";
	say "no=0";
	say "caret=1";
	say "page=0";
}
######################我是分割线##############################################
#按normal、hover、click排序状态栏同类图标
sub get_sorted_png{
	my $pattern=shift;
	my @pngs;
	foreach ( @file_lists ) {
		if ( -f $_ and /$pattern/ ) {
			push @pngs,$_;
		}
	}
	return map {$_->[2]} 
		   sort {$a->[0] cmp $b->[0] || $b->[1] cmp $a->[1]} 
		   map {[split(/_/,$_,2), $_]} @pngs;
}

#获取图片大小
sub get_imgsize {
	my $img_name=shift;
	my ($width,$height)=imgsize($img_name);
	return ($width,$height);
}

#获取图片名字
sub find_image_name {
	my $pattern=shift;
	foreach ( @file_lists ) {
		if ( -f $_ and /$pattern/ ) {
			return $_;
		}
	}
}

#由于有两地方需要打印bg= size= msize 属性，所以编了一个sub
sub print_background_and_size {
	my $pattern=shift;
	say "bg=",&find_image_name($pattern);
	say "size=",join ',',&get_imgsize(&find_image_name($pattern));
	say "msize=",join ',',&get_imgsize(&find_image_name($pattern));
}

