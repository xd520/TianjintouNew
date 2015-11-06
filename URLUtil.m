//
//  URLUtil.m
//  WeiXiu
//
//  Created by Chris on 13-7-15.
//  Copyright (c) 2013年 Chris. All rights reserved.
//

#import "URLUtil.h"
#import "AppDelegate.h"
@implementation URLUtil
+ (NSString *)getURLByBusinessTag:(kBusinessTag)tag
{
    //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    switch ([[NSNumber numberWithInt:tag] intValue]) {
        case 0:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/wytz"];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/zxzx"];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/wytz"];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/zxzx"];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/myfunds/fundslist"];
            break;
        case 5:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/login"];
            break;
        case 6:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/myfunds"];
            break;
        case 7:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/myfunds/fundslist"];
            break;
        case 8:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/yzusername"];
            break;
        case 9:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/myinv"];
            break;
        case 10:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/myinv/cancelWt"];
            break;
        case 11:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/myinv/confirmJK"];
            break;
        case 12:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/myprj"];
            break;
        case 13:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/psninfo/modifyPhotoSubmit"];
            break;
        case 14:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/myprj"];
            break;
        case 15:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/logout"];
        case 16:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/bankbusiness/bd"];
            break;
        case 17:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/bankbusiness/rj"];
            break;
        case 18:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/bankbusiness/isneedzjmm"];
            break;
        case 19:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/bankbusiness/cj"];
            break;
        case 20:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/banner"];
            break;
        case 21:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/industry"];
            break;
        case 22:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/province"];
            break;
        case 23:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/status"];
            break;
        case 24:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/city"];
            break;
        case 25:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/wytz"];
            break;
        case 26:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/bankbusiness/bank_info"];
            break;
        case 27:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/detail/"];
            break;
        case 28:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/rzf"];
            break;
        case 29:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/tzf"];
            break;
        case 30:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/invsigned/upfile"];
            break;
        case 31:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/yzmobile"];
            break;
        case 32:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/yzzjbh"];
            break;
        case 33:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/getyzm"];
            break;
        case 34:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/checkyzm"];
            break;
        case 35:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/oper/operate/iwleader"];
            break;
        case 36:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/oper/operate/iwfollow"];
            break;
        case 37:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/version/checkIos"];
            break;
        case 38:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/invsigned/upfile"];
            break;
        case 39:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/invsigned/upfile"];
            break;
        case 40:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/invsigned/sjTzr"];
            break;
        case 41:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/invsigned/ltrSq"];
            break;
        case 42:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/invsigned/ltrForm"];
            break;
        case 43:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/bankbusiness/isneedzjmm"];
            break;
        case 44:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/index/project/wytz"];
            break;
        case 45:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/yzmobile"];
            break;
        case 46:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/yzzjbh"];
            break;
        case 47:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/yzusername"];
            break;
        case 48:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/psncenter/invsigned/modifyTzr"];
            break;
        case 49:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/login"];
            break;
        case 50:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/logout"];
            break;
        case 51:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/captcha"];
            break;
        case 52:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/validateUsername"];
            break;
        case 53:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/validateMobilePhone"];
            break;
        case 54:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/sendVcode"];
            break;
        case 55:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/checkVcode"];
            break;
        case 56:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdzc/index"];
            break;
        case 57:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdzc/loginInfo"];
            break;
        case 58:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/index"];
            break;
        case 59:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/myfunds/fundslist"];
            break;
        case 60:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transRecord/transRecordList"];
            break;
        case 61:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzx/gqlb"];
            break;
        case 62:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzx/loadData"];
            break;
        case 63:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdtz/loadData"];
            break;
        case 64:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/wytz/loadData"];
            break;
        case 65:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/wytz/loadData"];
            break;
        case 66:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdsy/loadData"];
            break;
        case 67:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzx/loadData"];
            break;
        case 68:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzx/tz_detail"];
            break;
        case 69:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdzc/myJrzcPaging"];
            break;
        case 70:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdzc/myJrzcPaging"];
            break;
        case 71:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transRecord/transRecordList"];
            break;
        case 72:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transRecord/transRecordList"];
            break;
        case 73:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transRecord/transRecordList"];
            break;
        case 74:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/myfunds/fundslist"];
            break;
        case 75:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/myfunds/fundslist"];
            break;
        case 76:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/myfunds/fundslist"];
            break;
        case 77:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdsy/loadData"];
            break;
        case 78:  //63 6
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdtz/loadData"];
            break;
        case 79:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdtz/loadData"];
            break;
        case 80: //63 4
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdtz/loadData"];
            break;
        case 81:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdtz/loadData"];
            break;
        case 82: //63 2
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdtz/loadData"];
            break;
        case 83: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdtz/loadData"];
            break;
        case 84: //63 
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdtz/loadData"];
            break;
        case 85: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/wyzr/loadData"];
            break;
        case 86: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/wyzr/loadData"];
            break;
        case 87: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transAccount/applySaveAndOutMoneyIndex"];
            break;
        case 88: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transAccount/applySaveAndOutMoneyIndex"];
            break;
        case 89:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/sendVcode"];
            break;
        case 90:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/wytz/detail"];
            break;
        case 91:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdzhaq/index"];
            break;
        case 92:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transAccount/applySaveMoneySubmit"];
            break;
        case 93:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transAccount/applyOutMoneySubmit"];
            break;
        case 94:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/jrzcjy/cpzx/doTrade_app"];
            break;
        case 95:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/getSupBankList"];
            break;
        case 96:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/getSupBankList"];
            break;
        case 97:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/selling"];
            break;
        case 98:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/sendVcode"];
            break;
        case 99:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/bindBankCardSubmit"];
            break;
        case 100:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/unBindBankCardSubmit"];
            break;
        case 101: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/zjgl/index/transAccount/applySaveAndOutMoneyIndex"];
            break;
        case 102:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/hftx/bindCard/provinceData"];
            break;
        case 103: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/hftx/bindCard/provinceData"];
            break;
        case 104: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/hftx/bindCard/cityData"];
            break;
        case 105: //63
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/hftx/bindCard/cityData"];
            break;
        case 106:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/smrz/sendVcode"];
            break;
        case 107:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/smrz/realNameAuthentication"];
            break;
        case 108:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/isNeedPsw"];
            break;
        case 109:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/forgetpwd/step2"];
            break;
        case 110:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/account/resetJyPWD"];
            break;
        case 111:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/account/modifyTranPwdSubmit"];
            break;
        case 112:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/account/modifyLoginPwdSubmit"];
            break;
        case 113:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/account/updateUserInfo"];
            break;
        case 114:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/account/updateUserInfo"];
            break;
        case 115: //1
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/todayEntrustPage"];
            break;
        case 116:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/todayEntrustPage"];
            break;
        case 117://2
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/todayEntrustPage"];
            break;
        case 118:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/todayEntrustPage"];
            break;
        case 119://3
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/todayEntrustPage"];
            break;
        case 120:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/todayEntrustPage"];
            break;
        case 121: //4
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/todayEntrustPage"];
            break;
        case 122:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/todayEntrustPage"];
            break;
        case 123:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/entrustWithdraw"];
            break;
        case 124:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/entrustWithdraw"];
            break;
        case 125:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/entrustWithdraw"];
            break;
        case 126:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/entrust/entrustWithdraw"];
            break;
        case 127:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/website/hot_project"];
            break;
        case 128:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/smrz/sendVcode"];
            break;///app/wdzh/wdyhk/sfcg/bindCard/checkResult
        case 129:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/hftx/bindCard/checkResult"];
            break;
        case 130:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/doTrade"];
            break;
        case 131:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/wyzrdoTrade"];
            break;
        case 132:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/info/list"];
            break;
        case 133:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/info/list"];
            break;
        case 134:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/info/detail"];
            break;
        case 135:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/website/carouselImgUrl"];
            break;
        case 136:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/doPersonal"];
            break;
        case 137:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/myCoin/list"];
            break;
        case 138:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/myCoin/list"];
            break;
        case 139:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/myCoin/list"];
            break;
        case 140:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/myCoin/list"];
            break;
        case 141:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/myCoin/list"];
            break;
        case 142:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/myCoin/list"];
            break;
        case 143:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzx/tz_detail"];
            break;
        case 144:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzx/getSxf"];
            break;
        case 145:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzx/userCoinData"];
            break;
        case 146:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/favorites/favoritesList"];
            break;
        case 147:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/favorites/favoritesList"];
            break;
        case 148:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/favorites/add"];
            break;
        case 149:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/favorites/remove"];
            break;
        case 150:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/cpzr/wytz/detail"];
            break;
        case 151:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/info/list"];
            break;
        case 152:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/info/list"];
            break;
        case 153:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdsy/loadData"];
            break;
        case 154:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/jrzcjy/wdsy/loadData"];
            break;
        case 155:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/hftx/bindCard/provinceData"];
            break;
        case 156:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/wdyhk/hftx/bindCard/cityData"];
            break;
        case 157:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/wdzh/account/sendVcode"];
            break;
        case 158:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/forgetpwd/validateMobilePhone"];
            break;
        case 159:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/forgetpwd/sendVcode"];
            break;
        case 160:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/forgetpwd/resetPwd"];
            break;
        case 161:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/wdzh/wdqx/appCxTzqx"];
            break;
        case 162:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/wdzh/wdqx/tzqx"];
            break;
        case 163:
            return [NSString stringWithFormat:@"%@%@", SERVERURL, @"/service/jrzcjy/cpzx/appMyLpq"];
            break;
        case 164:
            return [NSString stringWithFormat:@"%@%@", SERVERURL,@"/service/website/zxlist/zxlistForAPP"];
            break;
        case 165:
            return [NSString stringWithFormat:@"%@%@", SERVERURL,@"/service/website/zxlist/zxlistForAPP"];
            break;
        case 166:
            return [NSString stringWithFormat:@"%@%@", SERVERURL,@"/service/jrzcjy/cpzx/appYyrgje"];
            break;
        case 167:
            return [NSString stringWithFormat:@"%@%@", SERVERURL,@"/service/jrzcjy/cpzx/appYyrgsq"];
            break;
        case 168:
            return [NSString stringWithFormat:@"%@%@", SERVERURL,@"/service/jrzcjy/cpzx/appYyrgjl"];
            break;
        case 169:
            return [NSString stringWithFormat:@"%@%@", SERVERURL,@"/service/jrzcjy/cpzx/appYyrgje"];
            break;
        case 170:
            return [NSString stringWithFormat:@"%@%@", SERVERURL,@"/service/jrzcjy/cpzx/appYyrgjl"];
            break;
        default:
            break;
    }
    return @"";
}
@end
