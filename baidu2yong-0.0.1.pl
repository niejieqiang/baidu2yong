#!/usr/bin/perl 
use strict;
use warnings;
use File::Find;
use Image::Size;
use File::Basename;
use Cwd;

my $input_x=20;							#候选词和编码出现的位置，他们在双行模式下应是一样的。
my $input_y=7;							#编码出现的位置
my $input_increment=24;					#编码和候选词之间的距离

my $toolbar_y=3;					    #状态栏小图标纵坐标,他们应该是一样的
my $toolbar_x=20;						#第一个图标的x坐标
my $toolbar_inrement=19;				#每个图标之间的距离
my $work_left=10;						#文字活动范围,注:和stretch不同,stretch= 是控制小小皮肤不被拉伸.
my $work_right=10;
my $space= 10;							#候选项之间的距离
my $first_color="\#1698e9";				#字体颜色
my $default_color="\#1698e9";
my $tip_color="\#000000";
my $page="\#1698e9";

my $cn=qr/chinese.*/;					#如果要修改sougo皮肤,改这些正则应该是可以d ...
my $en=qr/english/;
my $quan=qr/full/;
my $ban=qr/half/;
my $biaodian_en=qr/en_punctuation/;
my $biaodian_cn=qr/cn_punctuation/;
my $keyboard=qr/logout/;
my $menu=qr/setting/;

my $toolbar_bg=qr/toolbar_background\.png/;
my $input_bg=qr/main_backgroundH\.png/;

my $toolbar_sequence;
my ($toolbar_width, $toolbar_height);
my @a;
my @b;
my @c;
my @d;
my @e;
my @f;
my @g;
my @h;

#sort png sequence according normal,hover,click
my ($AA,$BB,$aa,$bb);
sub custom_sequence{
	($AA, $aa) = split(/_/, shift, 2);
	($BB, $bb) = split(/_/, shift, 2);
	return (($AA cmp $BB) or ($bb cmp $aa));
}

my $fold_name = getcwd;
$fold_name=basename($fold_name);
print "\#输入法名字\n\[about\]\nname=$fold_name\n";
print "\#icons\n\[tray\]\n";
print "icon=tray1\.png tray2\.png\n";

print "\n\#状态栏\n\[main\]\n";

my $dh=DirHandle->new(DIR,$ARGV[0] || ".") or die "open failure:$!";
my @file_list=$dh->read;
close $dh;

foreach (@file_list) {
	if(/$toolbar_bg/){
		($toolbar_width, $toolbar_height) = imgsize($_);
		print "\#候选窗设置\nbg=$_\n";
		print "size=$toolbar_width,$toolbar_height\n";
		print "msize=$toolbar_width,$toolbar_height\n";
		print "move=0,0,$toolbar_width,$toolbar_height\n";
	}
	elsif (/$cn/) {
		push @a,$_;
		if (@a) {
			@a=sort {custom_sequence($a, $b)} @a;
			$toolbar_sequence=join ",",@a;
			print "\#中英文图标位置和背景图片\n";
			print "lang=$toolbar_x,$toolbar_y\n";
			print "lang_cn=$toolbar_sequence\n";
		}
		else{
			print "\#中英文图标位置和背景图片\n";
			print "\#lang=$toolbar_x,$toolbar_y\n";
			print "\#lang_cn=$toolbar_sequence\n";
		}
		
	}
	elsif (/$en/) {
		push @b,$_;
		if (@b) {
			@b=sort {custom_sequence($a, $b)} @b;
			$toolbar_sequence=join ",",@b;
			print "lang_en=$toolbar_sequence\n";
		}
		else {
			print "\#lang_en=$toolbar_sequence\n";
		}
		
	}
	elsif (/$quan/) {
		push @c,$_;
		if (@c) {
			@c=sort {custom_sequence($a, $b)} @c;
			$toolbar_sequence=join ",",@c;
			print "\n\#全半角图标位置\n";
			print "corner=".($toolbar_x+$toolbar_inrement).",".$toolbar_y."\n";
			print "corner_full=$toolbar_sequence\n";
		}
		else {
			print "\n\#全半角图标位置\n";
			print "\#corner=".($toolbar_x+$toolbar_inrement).",".$toolbar_y."\n";
			print "\#corner_full=$toolbar_sequence\n";
		}
	}
	elsif (/$ban/) {
		push @d,$_;
		if (@d) {
			@d=sort {custom_sequence($a, $b)} @d;
			$toolbar_sequence=join ",",@d;
			print "corner_half=$toolbar_sequence\n";
		}
		else {
			print "\#corner_half=$toolbar_sequence\n";
		}
	}
	elsif (/$biaodian_en/) {
		push @e,$_;
		if (@e) {
			@e=sort {custom_sequence($a, $b)} @e;
			$toolbar_sequence=join ",",@e;
			print "\n\#中英文标点图标\n";
			print "biaodian=".($toolbar_x+$toolbar_inrement*2).",".$toolbar_y."\n";
			print "biaodian_en=$toolbar_sequence\n";
		}
		else {
			# body...
			print "\n\#中英文标点图标\n";
			print "\#biaodian=".($toolbar_x+$toolbar_inrement*2).",".$toolbar_y."\n";
			print "\#biaodian_en=$toolbar_sequence\n";
		}
	}
	elsif (/$biaodian_cn/) {
		push @f,$_;
		if(@f){
			@f=sort {custom_sequence($a, $b)} @f;
			$toolbar_sequence=join ",",@f;
			print "biaodian_cn=$toolbar_sequence\n";
		}
		else {
			print "\#biaodian_cn=$toolbar_sequence\n";
		}
	}
	elsif (/$keyboard/) {
		push @g,$_;
		if(@g){
			@g=sort {custom_sequence($a, $b)} @g;
			$toolbar_sequence=join ",",@g;
			print "\n\#键盘图标\n";
			print "keyboard=".($toolbar_x+$toolbar_inrement*3).",".$toolbar_y."\n";
			print "keyboard_img=$toolbar_sequence\n";
		}
		else {
			print "\n\#键盘图标\n";
			print "\#keyboard=".($toolbar_x+$toolbar_inrement*3).",".$toolbar_y."\n";
			print "\#keyboard_img=$toolbar_sequence\n";
		}
	}
	elsif (/$menu/) {
		push @h,$_;
		if (@h) {
			@h=sort {custom_sequence($a, $b)} @h;
			$toolbar_sequence=join ",",@h;
			print "\n\#菜单图标\n";
			print "menu=".($toolbar_x+$toolbar_inrement*4).",".$toolbar_y."\n";
			print "menu_img=$toolbar_sequence\n";
		}
		else{
			print "\n\#菜单图标\n";
			print "\#menu=".($toolbar_x+$toolbar_inrement*4).",".$toolbar_y."\n";
			print "\#menu_img=$toolbar_sequence\n";
		}
	}
}


print "\n\[input\]\n";
foreach (@file_list) {
	if(/$input_bg/){
		&handle_input;
	}
	elsif(/main_background\.png/){
		&handle_input;
	}
}

sub handle_input{
	($toolbar_width, $toolbar_height) = imgsize($_);
	print "\#状态栏设置\nbg=$_\n";
	print "\#大小设置\nsize=$toolbar_width,$toolbar_height\n";
	print "msize=$toolbar_width,$toolbar_height\n";
	print "\n\#图片防拉伸缩设置\nstretch=".(int($toolbar_width/2)).",".($toolbar_width-int($toolbar_width/2)-2)."\n";
	print "\#文字活动范围\nwork=$work_left,$work_right\n";
	print "\#编码出现位置\ncode=$input_x,$input_y\n";
	print "\#候选词出现位置\ncand=$input_x,".($input_y+$input_increment)."\n";
	print "space=$space\n";
	print "font=Arial 12\n";
	print "\#字体颜色\ncolor=$first_color,$default_color,$tip_color,$page\n";
	print "\n\#0:两行,1:单行,2:多行\nline=0\n";
	print "no=0\n";
	print "caret=1\n";
	print "page=0\n";

}
