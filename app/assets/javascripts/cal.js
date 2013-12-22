//本息还款的月还款额(参数: 年利率/贷款总额/贷款总月份)
function getMonthMoney1(lilv,total,month){
    var lilv_month = lilv / 12;//月利率
    return total * lilv_month * Math.pow(1 + lilv_month, month) / ( Math.pow(1 + lilv_month, month) -1 );
}

//得到利率
function getlilv(lilv_class,type,years){
    var lilv_class = parseInt(lilv_class);//新旧利率。1:旧利率，2:新利率
    if (lilv_class==2){
        //2005年	1月的新利率
        if (years<=5){
            if (type==2){
                return  0.0378;//公积金 1～5年 3.78%
            }else{
                return 0.0495;//商贷 1～5年 4.95%
            }
        }else{
            if (type==2){
                return  0.0423//公积金 5-30年 4.23%
            }else{
                return 0.0531//商贷 5-30年 5.31%
            }
        }
    }else if(lilv_class==3){
        //2006年	1月的新利率下限
        if (years<=5){
            if (type==2){
                return  0.0396//公积金 1～5年 3.96%
            }else{
                return 0.0495//商贷 1～5年 4.95%
            }
        }else{
            if (type==2){
                return  0.0441//公积金 5-30年 4.41%
            }else{
                return 0.0551//商贷 5-30年 5.51%
            }
        }
    }else if(lilv_class==4){
        //2006年	1月的新利率上限
        if (years<=5){
            if (type==2){
                return  0.0396//公积金 1～5年 3.96%
            }else{
                return 0.0495//商贷 1～5年 4.95%
            }
        }else{
            if (type==2){
                return  0.0441//公积金 5-30年 4.41%
            }else{
                return 0.0612//商贷 5-30年 6.12%
            }
        }
    }else if(lilv_class==5){
        //2006年	4月的新利率上限
        if (years<=5){
            if (type==2){
                return  0.0414//公积金 1～5年 3.96%
            }else{
                return 0.0612//商贷 1～5年 4.95%
            }
        }else{
            if (type==2){
                return  0.0459//公积金 5-30年 4.41%
            }else{
                return 0.0639//商贷 5-30年 6.12%
            }
        }
    }else if(lilv_class==6){
        //2006年	8月的新利率上限
        if (years<=5){
            if (type==2){
                return  0.0414//公积金 1～5年 3.96%
            }else{
                return 0.0648//商贷 1～5年 4.95%
            }
        }else{
            if (type==2){
                return  0.0459//公积金 5-30年 4.41%
            }else{
                return 0.0684//商贷 5-30年 6.12%
            }
        }
    }else if(lilv_class==7){
        //2007年	3月的新利率下限
        if (years<=5){
            if (type==2){
                return  0.0432//公积金 1～5年 3.96%
            }else{
                return 0.057375//商贷 1～5年 4.95%
            }
        }else{
            if (type==2){
                return  0.0477//公积金 5-30年 4.41%
            }else{
                return 0.060435//商贷 5-30年 6.12%
            }
        }
    }else if(lilv_class==8){
        //2007年	3月的新基准利率
        if (years<=5){
            if (type==2){
                return  0.0432//公积金 1～5年 3.96%
            }else{
                return 0.0675//商贷 1～5年 4.95%
            }
        }else{
            if (type==2){
                return  0.0477//公积金 5-30年 4.41%
            }else{
                return 0.0711//商贷 5-30年 6.12%
            }
        }
    }else if(lilv_class==9){
        //2007年	5月的新利率下限
        if (years<=5){
            if (type==2){
                return  0.0441//公积金 1～5年
            }else{
                return 0.058905//商贷 1～5年
            }
        }else{
            if (type==2){
                return  0.0486//公积金 5-30年
            }else{
                return 0.0612//商贷 5-30年
            }
        }
    }else if(lilv_class==10){
        //2007年	5月的新基准利率
        if (years<=5){
            if (type==2){
                return  0.0441//公积金 1～5年
            }else{
                return 0.0693//商贷 1～5年
            }
        }else{
            if (type==2){
                return  0.0486//公积金 5-30年
            }else{
                return 0.0720//商贷 5-30年
            }
        }

    }else if(lilv_class==11){
        //2007年	7月的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0450 //公积金 1年
            }else{
                return 0.06840 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0450 //公积金 2～3年
            }else{
                return 0.07020 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0450 //公积金 4～5年
            }else{
                return 0.0720//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0495 //公积金5年以上
            }else{
                return 0.0738 //商贷5年以上
            }
        }

    }else if(lilv_class==12){
        //2007年	7月的新基准利率下限
        if (years<=1){
            if (type==2){
                return  0.0450 //公积金 1年
            }else{
                return 0.05814 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0450 //公积金 2～3年
            }else{
                return 0.05967 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0450 //公积金 4～5年
            }else{
                return 0.06120//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0495 //公积金5年以上
            }else{
                return 0.06273 //商贷5年以上
            }
        }

    }else if(lilv_class==13){
        //2007年	8月的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0459 //公积金 1年
            }else{
                return 0.0702 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0459 //公积金 2～3年
            }else{
                return 0.0720 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0459 //公积金 4～5年
            }else{
                return 0.0738//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0504 //公积金5年以上
            }else{
                return 0.0756 //商贷5年以上
            }
        }
    }else if(lilv_class==14){
        //2007年	8月的利率下限
        if (years<=1){
            if (type==2){
                return  0.0459 //公积金 1年
            }else{
                return 0.05967 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0459 //公积金 2～3年
            }else{
                return 0.0612 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0459 //公积金 4～5年
            }else{
                return 0.06273//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0504 //公积金5年以上
            }else{
                return 0.06426 //商贷5年以上
            }
        }

    }else if(lilv_class==15){
        //2007年	9月的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0477 //公积金 1年
            }else{
                return 0.0729 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0477 //公积金 2～3年
            }else{
                return 0.0747 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0477 //公积金 4～5年
            }else{
                return 0.0765//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0522 //公积金5年以上
            }else{
                return 0.0783 //商贷5年以上
            }
        }

    }else if(lilv_class==16){
        //2007年	9月的利率下限
        if (years<=1){
            if (type==2){
                return  0.0477 //公积金 1年
            }else{
                return 0.061965 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0477 //公积金 2～3年
            }else{
                return 0.063495 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0477 //公积金 4～5年
            }else{
                return 0.065025//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0522 //公积金5年以上
            }else{
                return 0.066555 //商贷5年以上
            }
        }

    }else if(lilv_class==17){
        //2007年	12月的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0477 //公积金 1年
            }else{
                return 0.0747 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0477 //公积金 2～3年
            }else{
                return 0.0756 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0477 //公积金 4～5年
            }else{
                return 0.0774//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0522 //公积金5年以上
            }else{
                return 0.0783 //商贷5年以上
            }
        }

    }else if(lilv_class==18){
        //2007年	12月的利率下限
        if (years<=1){
            if (type==2){
                return  0.0477 //公积金 1年
            }else{
                return 0.063495 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0477 //公积金 2～3年
            }else{
                return 0.064515 //商贷 2～3年 0.0756
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0477 //公积金 4～5年
            }else{
                return 0.06579//商贷 4～5年 0.0774
            }
        }

        if (years>5){
            if (type==2){
                return  0.0522 //公积金5年以上
            }else{
                return 0.066555 //商贷5年以上 0.0783
            }
        }

    }else if(lilv_class==19){
        //2007年12月的利率上限
        if (years<=1){
            if (type==2){
                return  0.0477 //公积金 1年
            }else{
                return 0.0698445 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0477 //公积金 2～3年
            }else{
                return 0.0709665 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0477 //公积金 4～5年
            }else{
                return 0.072369//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0522 //公积金5年以上
            }else{
                return 0.0732105 //商贷5年以上
            }
        }

    }else if(lilv_class==20){
        //2008年	9月的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0459 //公积金 1年
            }else{
                return 0.0720 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0459 //公积金 2～3年
            }else{
                return 0.0729 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0459 //公积金 4～5年
            }else{
                return 0.0756//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0513 //公积金5年以上
            }else{
                return 0.0774 //商贷5年以上
            }
        }

    }else if(lilv_class==21){
        //2008年	9月的利率下限
        if (years<=1){
            if (type==2){
                return  0.0459 //公积金 1年
            }else{
                return 0.0612 //商贷 1年 0.072
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0459 //公积金 2～3年
            }else{
                return 0.061965 //商贷 2～3年 0.0729
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0459 //公积金 4～5年
            }else{
                return 0.06426//商贷 4～5年 0.0756
            }
        }

        if (years>5){
            if (type==2){
                return  0.0513 //公积金5年以上
            }else{
                return 0.06579 //商贷5年以上 0.0774
            }
        }

    }else if(lilv_class==22){
        //2008年9月的利率上限
        if (years<=1){
            if (type==2){
                return  0.0459 //公积金 1年
            }else{
                return 0.0792 //商贷 1年 0.0720
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0459 //公积金 2～3年
            }else{
                return 0.08019 //商贷 2～3年 0.0729
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0459 //公积金 4～5年
            }else{
                return 0.08316//商贷 4～5年 0.0756
            }
        }

        if (years>5){
            if (type==2){
                return  0.0513 //公积金5年以上
            }else{
                return 0.08514 //商贷5年以上 0.0774
            }
        }

    }else if(lilv_class==23){
        //2008年	10月的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0432 //公积金 1年
            }else{
                return 0.0693 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0432 //公积金 2～3年
            }else{
                return 0.0702 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0432 //公积金 4～5年
            }else{
                return 0.0729//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0486 //公积金5年以上
            }else{
                return 0.0747 //商贷5年以上
            }
        }

    }else if(lilv_class==24){
        //2008年	10月的利率下限
        if (years<=1){
            if (type==2){
                return  0.0432 //公积金 1年
            }else{
                return 0.058905 //商贷 1年 0.0693
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0432 //公积金 2～3年
            }else{
                return 0.05967 //商贷 2～3年 0.0702
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0432 //公积金 4～5年
            }else{
                return 0.061965//商贷 4～5年 0.0729
            }
        }

        if (years>5){
            if (type==2){
                return  0.0486 //公积金5年以上
            }else{
                return 0.063495 //商贷5年以上 0.0747
            }
        }

    }else if(lilv_class==25){
        //2008年10月的利率上限
        if (years<=1){
            if (type==2){
                return  0.0432 //公积金 1年
            }else{
                return 0.07623 //商贷 1年 0.0693
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0432 //公积金 2～3年
            }else{
                return 0.07722 //商贷 2～3年 0.0702
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0432 //公积金 4～5年
            }else{
                return 0.08019//商贷 4～5年 0.0729
            }
        }

        if (years>5){
            if (type==2){
                return  0.0486 //公积金5年以上
            }else{
                return 0.08217 //商贷5年以上 0.0747
            }
        }

    }else if(lilv_class==26){
        //2008年	10月27的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0405 //公积金 1年
            }else{
                return 0.0693 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0405 //公积金 2～3年
            }else{
                return 0.0702 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0405 //公积金 4～5年
            }else{
                return 0.0729//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0459 //公积金5年以上
            }else{
                return 0.0747 //商贷5年以上
            }
        }

    }else if(lilv_class==27){
        //2008年	10月27的利率下限
        if (years<=1){
            if (type==2){
                return  0.0405 //公积金 1年
            }else{
                return 0.04851 //商贷 1年 0.0693
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0405 //公积金 2～3年
            }else{
                return 0.04914 //商贷 2～3年 0.0702
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0405 //公积金 4～5年
            }else{
                return 0.05103//商贷 4～5年 0.0729
            }
        }

        if (years>5){
            if (type==2){
                return  0.0459 //公积金5年以上
            }else{
                return 0.05229 //商贷5年以上 0.0747
            }
        }

    }else if(lilv_class==28){
        //2008年	10月30的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0405 //公积金 1年
            }else{
                return 0.0666 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0405 //公积金 2～3年
            }else{
                return 0.0675 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0405 //公积金 4～5年
            }else{
                return 0.0702//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0459 //公积金5年以上
            }else{
                return 0.072 //商贷5年以上
            }
        }

    }else if(lilv_class==29){
        //2008年	10月30的利率下限30%
        if (years<=1){
            if (type==2){
                return  0.0405 //公积金 1年
            }else{
                return 0.04662 //商贷 1年 0.0666
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0405 //公积金 2～3年
            }else{
                return 0.04725 //商贷 2～3年 0.0675
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0405 //公积金 4～5年
            }else{
                return 0.04914//商贷 4～5年 0.0702
            }
        }

        if (years>5){
            if (type==2){
                return  0.0459 //公积金5年以上
            }else{
                return 0.0504 //商贷5年以上 0.072
            }
        }

    }else if(lilv_class==30){
        //2008年	10月30的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.0405 //公积金 1年
            }else{
                return 0.05661 //商贷 1年 0.0666
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0405 //公积金 2～3年
            }else{
                return 0.057375 //商贷 2～3年 0.0675
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0405 //公积金 4～5年
            }else{
                return 0.05967//商贷 4～5年 0.0702
            }
        }

        if (years>5){
            if (type==2){
                return  0.0459 //公积金5年以上
            }else{
                return 0.0612 //商贷5年以上 0.072
            }
        }

    }else if(lilv_class==31){
        //2008年	11月27的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0351 //公积金 1年
            }else{
                return 0.0558 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0351 //公积金 2～3年
            }else{
                return 0.0567 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0351 //公积金 4～5年
            }else{
                return 0.0594//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0405 //公积金5年以上
            }else{
                return 0.0612 //商贷5年以上
            }
        }

    }else if(lilv_class==32){
        //2008年	11月27的利率下限30%
        if (years<=1){
            if (type==2){
                return  0.0351 //公积金 1年
            }else{
                return 0.03906 //商贷 1年 0.0558
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0351 //公积金 2～3年
            }else{
                return 0.03969 //商贷 2～3年 0.0567
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0351 //公积金 4～5年
            }else{
                return 0.04158//商贷 4～5年 0.0594
            }
        }

        if (years>5){
            if (type==2){
                return  0.0405 //公积金5年以上
            }else{
                return 0.04284 //商贷5年以上 0.0612
            }
        }

    }else if(lilv_class==33){
        //2008年	11月27的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.0351 //公积金 1年
            }else{
                return 0.04743 //商贷 1年 0.0558
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0351 //公积金 2～3年
            }else{
                return 0.048195 //商贷 2～3年 0.0567
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0351 //公积金 4～5年
            }else{
                return 0.05049//商贷 4～5年 0.0594
            }
        }

        if (years>5){
            if (type==2){
                return  0.0405 //公积金5年以上
            }else{
                return 0.05202 //商贷5年以上 0.0612
            }
        }

    }else if(lilv_class==34){
        //2008年	12月23的新基准利率
        if (years<=1){
            if (type==2){
                return  0.0333 //公积金 1年
            }else{
                return 0.0531 //商贷 1年
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0333 //公积金 2～3年
            }else{
                return 0.0540 //商贷 2～3年
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0333 //公积金 4～5年
            }else{
                return 0.0576//商贷 4～5年
            }
        }

        if (years>5){
            if (type==2){
                return  0.0387 //公积金5年以上
            }else{
                return 0.0594 //商贷5年以上
            }
        }

    }else if(lilv_class==35){
        //2008年	12月23的利率下限30%
        if (years<=1){
            if (type==2){
                return  0.0333 //公积金 1年
            }else{
                return 0.03717 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0333 //公积金 2～3年
            }else{
                return 0.0378 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0333 //公积金 4～5年
            }else{
                return 0.04032//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0387 //公积金5年以上
            }else{
                return 0.04158 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==36){
        //2008年	12月23的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.0333 //公积金 1年
            }else{
                return 0.045135 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0333 //公积金 2～3年
            }else{
                return 0.0459 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0333 //公积金 4～5年
            }else{
                return 0.04896//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0387 //公积金5年以上
            }else{
                return 0.05049 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==37){
        //2008年	12月23的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.0333 //公积金 1年
            }else{
                return 0.05841 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0333 //公积金 2～3年
            }else{
                return 0.0594 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0333 //公积金 4～5年
            }else{
                return 0.06336//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0387 //公积金5年以上
            }else{
                return 0.06534 //商贷5年以上 0.0594
            }
        }


    }else if(lilv_class==40){
        //2010年	10月20的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.0350 //公积金 1年
            }else{
                return 0.06116 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0350 //公积金 2～3年
            }else{
                return 0.0616 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0350 //公积金 4～5年
            }else{
                return 0.06556//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0405 //公积金5年以上
            }else{
                return 0.06754 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==39){
        //2010年	10月20的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.0350 //公积金 1年
            }else{
                return 0.04726 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0350 //公积金 2～3年
            }else{
                return 0.0476 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0350 //公积金 4～5年
            }else{
                return 0.05066//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0405 //公积金5年以上
            }else{
                return 0.05219 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==38){
        //2010年	10月20的利率
        if (years<=1){
            if (type==2){
                return  0.0350 //公积金 1年
            }else{
                return 0.0556 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0350 //公积金 2～3年
            }else{
                return 0.0560 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0350 //公积金 4～5年
            }else{
                return 0.0596//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0405 //公积金5年以上
            }else{
                return 0.0614 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==41){
        //2010年	10月20的利率下限30%
        if (years<=1){
            if (type==2){
                return  0.0350 //公积金 1年
            }else{
                return 0.03892 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0350 //公积金 2～3年
            }else{
                return 0.0392 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0350 //公积金 4～5年
            }else{
                return 0.04172//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0405 //公积金5年以上
            }else{
                return 0.04298 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==42){
        //2010年	12月26的利率
        if (years<=1){
            if (type==2){
                return  0.0375 //公积金 1年
            }else{
                return 0.0581 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0375 //公积金 2～3年
            }else{
                return 0.0585 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0375 //公积金 4～5年
            }else{
                return 0.0622//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0430 //公积金5年以上
            }else{
                return 0.0640 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==43){
        //2010年	12月26的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.0375 //公积金 1年
            }else{
                return 0.06391 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0375 //公积金 2～3年
            }else{
                return 0.06435 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0375 //公积金 4～5年
            }else{
                return 0.06842//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0430 //公积金5年以上
            }else{
                return 0.0704 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==44){
        //2010年	12月26的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.0375 //公积金 1年
            }else{
                return 0.049385 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0375 //公积金 2～3年
            }else{
                return 0.049725 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0375 //公积金 4～5年
            }else{
                return 0.05287//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0430 //公积金5年以上
            }else{
                return 0.0544 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==45){
        //2010年	12月26的利率下限30%
        if (years<=1){
            if (type==2){
                return  0.0375 //公积金 1年
            }else{
                return 0.04067 //商贷 1年 0.0531
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0375 //公积金 2～3年
            }else{
                return 0.04095 //商贷 2～3年 0.0540
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0375 //公积金 4～5年
            }else{
                return 0.04354//商贷 4～5年 0.0576
            }
        }

        if (years>5){
            if (type==2){
                return  0.0430 //公积金5年以上
            }else{
                return 0.0448 //商贷5年以上 0.0594
            }
        }

    }else if(lilv_class==46){
        //2011年	2月9的利率
        if (years<=1){
            if (type==2){
                return  0.04 //公积金 1年
            }else{
                return 0.0606 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.04 //公积金 2～3年
            }else{
                return 0.0610 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.04 //公积金 4～5年
            }else{
                return 0.0645//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.0450 //公积金5年以上
            }else{
                return 0.0660 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==47){
        //2011年	2月9的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.04 //公积金 1年
            }else{
                return 0.06666 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.04 //公积金 2～3年
            }else{
                return 0.0671 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.04 //公积金 4～5年
            }else{
                return 0.07095//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.0450 //公积金5年以上
            }else{
                return 0.0726 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==48){
        //2011年	2月9的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.04 //公积金 1年
            }else{
                return 0.05151 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.04 //公积金 2～3年
            }else{
                return 0.05185 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.04 //公积金 4～5年
            }else{
                return 0.054825//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.0450 //公积金5年以上
            }else{
                return 0.0561 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==49){
        //2011年	2月9的利率下限30%
        if (years<=1){
            if (type==2){
                return  0.04 //公积金 1年
            }else{
                return 0.04242 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.04 //公积金 2～3年
            }else{
                return 0.0427 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.04 //公积金 4～5年
            }else{
                return 0.04515//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.0450 //公积金5年以上
            }else{
                return 0.0462 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==50){
        //2011年	4月6的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.042 //公积金 1年
            }else{
                return 0.0631 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 //公积金 2～3年
            }else{
                return 0.064 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 //公积金 4～5年
            }else{
                return 0.0665//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 //公积金5年以上
            }else{
                return 0.0680 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==51){
        //2011年	4月6的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.042 //公积金 1年
            }else{
                return 0.06941 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 //公积金 2～3年
            }else{
                return 0.0704 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 //公积金 4～5年
            }else{
                return 0.07315//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 //公积金5年以上
            }else{
                return 0.0748 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==52){
        //2011年	4月6的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.042 //公积金 1年
            }else{
                return 0.053635 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 //公积金 2～3年
            }else{
                return 0.0544 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 //公积金 4～5年
            }else{
                return 0.056525//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 //公积金5年以上
            }else{
                return 0.0578 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==53){
        //2011年	4月6的利率下限30%
        if (years<=1){
            if (type==2){
                return  0.042 //公积金 1年
            }else{
                return 0.04417 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 //公积金 2～3年
            }else{
                return 0.0448 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 //公积金 4～5年
            }else{
                return 0.04655//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 //公积金5年以上
            }else{
                return 0.0476 //商贷5年以上 0.0660
            }
        }////////////////////////////////////////////////////////////////////////////////////////////////

    }else if(lilv_class==54){
        //2011年	7月7的利率
        if (years<=1){
            if (type==2){
                return  0.0445 //公积金 1年
            }else{
                return 0.0656 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0445 //公积金 2～3年
            }else{
                return 0.0665 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0445 //公积金 4～5年
            }else{
                return 0.069//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.049 //公积金5年以上
            }else{
                return 0.0705 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==55){
        //2011年	7月7的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.0445 //公积金 1年
            }else{
                return 0.07216 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0445 //公积金 2～3年
            }else{
                return 0.07315 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0445 //公积金 4～5年
            }else{
                return 0.0759//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.049 //公积金5年以上
            }else{
                return 0.07755 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==56){
        //2011年	7月7的利率下限30%
        if (years<=1){
            if (type==2){
                return  0.0445 //公积金 1年
            }else{
                return 0.04592 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0445 //公积金 2～3年
            }else{
                return 0.04655 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0445 //公积金 4～5年
            }else{
                return 0.0483//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.049 //公积金5年以上
            }else{
                return 0.04935 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==57){
        //2011年	7月7的利率下限15%
        if (years<=1){
            if (type==2){
                return  0.0445 //公积金 1年
            }else{
                return 0.05576 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0445 //公积金 2～3年
            }else{
                return 0.056525 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0445 //公积金 4～5年
            }else{
                return 0.05865//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.049 //公积金5年以上
            }else{
                return 0.059925 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==58){
        //2011年	10.24的利率
        if (years<=1){
            if (type==2){
                return  0.0445 //公积金 1年
            }else{
                return 0.0656 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0445 //公积金 2～3年
            }else{
                return 0.0665 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0445 //公积金 4～5年
            }else{
                return 0.069//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.049 //公积金5年以上
            }else{
                return 0.0705 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==59){
        //2011年	10.24的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.0445 //公积金 1年
            }else{
                return 0.07216 //商贷 1年 0.0606
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.0445 //公积金 2～3年
            }else{
                return 0.07315 //商贷 2～3年 0.0610
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.0445 //公积金 4～5年
            }else{
                return 0.0759//商贷 4～5年 0.0645
            }
        }

        if (years>5){
            if (type==2){
                return  0.0539 //公积金5年以上上浮10%
            }else{
                return 0.07755 //商贷5年以上 0.0660
            }
        }

    }else if(lilv_class==60){
        //2012年	6.8的利率
        if (years<=1){
            if (type==2){
                return  0.042 //公积金 1年
            }else{
                return 0.0631 //商贷 1年 0.0631
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 //公积金 2～3年
            }else{
                return 0.064 //商贷 2～3年 0.064
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 //公积金 4～5年
            }else{
                return 0.0665//商贷 4～5年 0.0665
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 //公积金5年以上
            }else{
                return 0.068 //商贷5年以上 0.068
            }
        }

    }else if(lilv_class==60){
        //2012年	6.8的利率
        if (years<=1){
            if (type==2){
                return  0.042 //公积金 1年
            }else{
                return 0.0631 //商贷 1年 0.0631
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 //公积金 2～3年
            }else{
                return 0.064 //商贷 2～3年 0.064
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 //公积金 4～5年
            }else{
                return 0.0665//商贷 4～5年 0.0665
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 //公积金5年以上
            }else{
                return 0.068 //商贷5年以上 0.068
            }
        }

    }else if(lilv_class==61){
        //2012年	6.8的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.042 * 1.1 //公积金 1年
            }else{
                return 0.0631 * 1.1 //商贷 1年 0.0631
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 * 1.1 //公积金 2～3年
            }else{
                return 0.064 * 1.1 //商贷 2～3年 0.064
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 * 1.1 //公积金 4～5年
            }else{
                return 0.0665 * 1.1 //商贷 4～5年 0.0665
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 * 1.1 //公积金5年以上
            }else{
                return 0.068 * 1.1 //商贷5年以上 0.068
            }
        }

    }else if(lilv_class==62){
        //2012年	6.8的利率下浮15%
        if (years<=1){
            if (type==2){
                return  0.042 * 0.85 //公积金 1年
            }else{
                return 0.0631 * 0.85 //商贷 1年 0.0631
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 * 0.85 //公积金 2～3年
            }else{
                return 0.064 * 0.85 //商贷 2～3年 0.064
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 * 0.85 //公积金 4～5年
            }else{
                return 0.0665 * 0.85 //商贷 4～5年 0.0665
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 * 0.85 //公积金5年以上
            }else{
                return 0.068 * 0.85 //商贷5年以上 0.068
            }
        }

    }else if(lilv_class==63){
        //2012年	6.8的利率下浮20%
        if (years<=1){
            if (type==2){
                return  0.042 * 0.8 //公积金 1年
            }else{
                return 0.0631 * 0.8 //商贷 1年 0.0631
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 * 0.8 //公积金 2～3年
            }else{
                return 0.064 * 0.8 //商贷 2～3年 0.064
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 * 0.8 //公积金 4～5年
            }else{
                return 0.0665 * 0.8 //商贷 4～5年 0.0665
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 * 0.8 //公积金5年以上
            }else{
                return 0.068 * 0.8 //商贷5年以上 0.068
            }
        }

    }else if(lilv_class==64){
        //2012年	6.8的利率下浮30%
        if (years<=1){
            if (type==2){
                return  0.042 * 0.7 //公积金 1年
            }else{
                return 0.0631 * 0.7 //商贷 1年 0.0631
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.042 * 0.7 //公积金 2～3年
            }else{
                return 0.064 * 0.7 //商贷 2～3年 0.064
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.042 * 0.7 //公积金 4～5年
            }else{
                return 0.0665 * 0.7 //商贷 4～5年 0.0665
            }
        }

        if (years>5){
            if (type==2){
                return  0.047 * 0.7 //公积金5年以上
            }else{
                return 0.068 * 0.7 //商贷5年以上 0.068
            }
        }

    }else if(lilv_class==65){
        //2012年	6.8的利率
        if (years<=1){
            if (type==2){
                return  0.040 //公积金 1年
            }else{
                return 0.060 //商贷 1年 0.0631
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.040 //公积金 2～3年
            }else{
                return 0.0615 //商贷 2～3年 0.0615
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.040 //公积金 4～5年
            }else{
                return 0.0640//商贷 4～5年 0.0640
            }
        }

        if (years>5){
            if (type==2){
                return  0.045 //公积金5年以上
            }else{
                return 0.0655 //商贷5年以上 0.065
            }
        }

    }else if(lilv_class==66){
        //2012年	6.8的利率上浮10%
        if (years<=1){
            if (type==2){
                return  0.040 * 1.1 //公积金 1年
            }else{
                return 0.060 * 1.1 //商贷 1年 0.060
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.040 * 1.1 //公积金 2～3年
            }else{
                return 0.0615 * 1.1 //商贷 2～3年 0.0615
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.040 * 1.1 //公积金 4～5年
            }else{
                return 0.0640 * 1.1 //商贷 4～5年 0.0640
            }
        }

        if (years>5){
            if (type==2){
                return  0.045 * 1.1 //公积金5年以上
            }else{
                return 0.0655 * 1.1 //商贷5年以上 0.0655
            }
        }

    }else if(lilv_class==67){
        //2012年	6.8的利率下浮15%
        if (years<=1){
            if (type==2){
                return  0.040 * 0.85 //公积金 1年
            }else{
                return 0.060 * 0.85 //商贷 1年 0.060
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.040 * 0.85 //公积金 2～3年
            }else{
                return 0.0615 * 0.85 //商贷 2～3年 0.0615
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.040 * 0.85 //公积金 4～5年
            }else{
                return 0.0640 * 0.85 //商贷 4～5年 0.0640
            }
        }

        if (years>5){
            if (type==2){
                return  0.045 * 0.85 //公积金5年以上
            }else{
                return 0.0655 * 0.85 //商贷5年以上 0.0655
            }
        }

    }else if(lilv_class==68){
        //2012年	6.8的利率下浮20%
        if (years<=1){
            if (type==2){
                return  0.040 * 0.8 //公积金 1年
            }else{
                return 0.060 * 0.8 //商贷 1年 0.060
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.040 * 0.8 //公积金 2～3年
            }else{
                return 0.0615 * 0.8 //商贷 2～3年 0.0615
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.040 * 0.8 //公积金 4～5年
            }else{
                return 0.0640 * 0.8 //商贷 4～5年 0.0640
            }
        }

        if (years>5){
            if (type==2){
                return  0.045 * 0.8 //公积金5年以上
            }else{
                return 0.0655 * 0.8 //商贷5年以上 0.0655
            }
        }

    }else if(lilv_class==69){
        //2012年	6.8的利率下浮30%
        if (years<=1){
            if (type==2){
                return  0.040 * 0.7 //公积金 1年
            }else{
                return 0.060 * 0.7 //商贷 1年 0.060
            }
        }

        if (years==2 || years==3){
            if (type==2){
                return  0.040 * 0.7 //公积金 2～3年
            }else{
                return 0.0615 * 0.7 //商贷 2～3年 0.0615
            }
        }

        if (years==4 || years==5){
            if (type==2){
                return  0.040 * 0.7 //公积金 4～5年
            }else{
                return 0.0640 * 0.7 //商贷 4～5年 0.0640
            }
        }

        if (years>5){
            if (type==2){
                return  0.045 * 0.7 //公积金5年以上
            }else{
                return 0.0655 * 0.7 //商贷5年以上 0.0655
            }
        }

    }else{
        //2004年之前的旧利率
        if (years<=5){
            if (type==2){
                return  0.0360//公积金 1～5年 3.60%
            }else{
                return 0.0477//商贷 1～5年 4.77%
            }
        }else{
            if (type==2){
                return  0.0405//公积金 5-30年 4.05%
            }else{
                return 0.0504//商贷 5-30年 5.04%
            }
        }
    }
}