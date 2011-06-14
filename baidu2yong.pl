#!/usr/bin/perl 
use strict;
use warnings;
use File::Find;
use Image::Magick;
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

my $cn=qw/chinese.*/;					#如果要修改sougo皮肤,改这些正则应该是可以d ...
my $en=qw/english/;
my $quan=qw/full/;
my $ban=qw/half/;
my $biaodian_en=qw/en_punctuation/;
my $biaodian_cn=qw/cn_punctuation/;
my $keyboard=qw/logout/;
my $menu=qw/setting/;

my $main_bg=qw/toolbar_background\.png/;
my $input_bg=qw/main_backgroundH\.png/;

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


my $fold_name = getcwd;
$fold_name=basename($fold_name);

find(\&wanted,$ARGV[0] || ".");

sub wanted{
	if(-f $_ and /$cn/){ 
		push ( @a, $_);
	}
	elsif(-f _ and /$en/){
		push (@b,$_);
	}
	elsif(-f _ and /$quan/){
		push ( @c,$_);
	}
	elsif(-f _ and /$ban/){
		push (@d,$_);
	}
	elsif(-f _ and /$biaodian_en/){
		push (@e,$_);
	}
	elsif(-f _ and /$biaodian_cn/){
		push (@f,$_);
	}
	elsif (-f _ and /$keyboard/){
		push (@g,$_);
	}
	elsif(-f _ and /$menu/){
		push (@h,$_);
	}
}

#sort png sequence according normal,hover,click
my ($AA,$BB,$aa,$bb);
sub custom_sequence{
	($AA, $aa) = split(/_/, shift, 2);
	($BB, $bb) = split(/_/, shift, 2);
	return (($AA cmp $BB) or ($bb cmp $aa));
}


print "\#输入法名字\n\[about\]\nname=$fold_name\n";
print "\#icons\n\[tray\]\n";
print "icon=tray1\.png tray2\.png\n";

print "\n\#状态栏\n\[main\]\n";
find(\&get_toolbar_size,$ARGV[0] || ".");
sub get_toolbar_size{
	if(-f $_ and /$main_bg/){
		my $image = Image::Magick->new;
		($toolbar_width, $toolbar_height) = $image->Ping($_);
		print "\#候选窗设置\nbg=$_\n";
		print "size=$toolbar_width,$toolbar_height\n";
		print "msize=$toolbar_width,$toolbar_height\n";
		print "move=0,0,$toolbar_width,$toolbar_height\n";
	}
}

@a=sort {custom_sequence($a, $b)} @a;
$toolbar_sequence=join ",",@a;
print "\#中英文图标位置和背景图片\n";
print "lang=$toolbar_x,$toolbar_y\n";
print "lang_cn=$toolbar_sequence\n";
@b=sort {custom_sequence($a, $b)} @b;
$toolbar_sequence=join ",",@b;
print "lang_en=$toolbar_sequence\n";


@c=sort {custom_sequence($a, $b)} @c;
$toolbar_sequence=join ",",@c;
print "\n\#全半角图标位置\n";
print "corner=".($toolbar_x+$toolbar_inrement).",".$toolbar_y."\n";
print "corner_full=$toolbar_sequence\n";
@d=sort {custom_sequence($a, $b)} @d;
$toolbar_sequence=join ",",@d;
print "corner_half=$toolbar_sequence\n";

@e=sort {custom_sequence($a, $b)} @e;
$toolbar_sequence=join ",",@e;
print "\n\#中英文标点图标\n";
print "biaodian=".($toolbar_x+$toolbar_inrement*2).",".$toolbar_y."\n";
print "biaodian_en=$toolbar_sequence\n";
@f=sort {custom_sequence($a, $b)} @f;
$toolbar_sequence=join ",",@f;
print "biaodian_cn=$toolbar_sequence\n";

@g=sort {custom_sequence($a, $b)} @g;
$toolbar_sequence=join ",",@g;
print "\n\#键盘图标\n";
print "keyboard=".($toolbar_x+$toolbar_inrement*3).",".$toolbar_y."\n";
print "keyboard_img=$toolbar_sequence\n";

@h=sort {custom_sequence($a, $b)} @h;
$toolbar_sequence=join ",",@h;
print "\n\#菜单图标\n";
print  "menu=".($toolbar_x+$toolbar_inrement*4).",".$toolbar_y."\n";
print "menu_img=$toolbar_sequence\n";



print "\n\[input\]\n";
find(\&getsize,$ARGV[0] || ".");
sub getsize{
	if(-f $_ and /$input_bg/){
		my $image = Image::Magick->new;
		($toolbar_width, $toolbar_height) = $image->Ping($_);
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
}
