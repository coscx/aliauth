import 'package:flutter/material.dart';
import 'package:ali_auth/ali_auth.dart';
import 'dart:io';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


/// 获取token成功
const PNSCodeSuccess = "600000";

/// 点击切换按钮，⽤户取消免密登录
const NSCodeLoginControllerClickChangeBtn = "700001";

/// 唤起授权页失败
const PNSCodeFail = "600002";

/// 一键登录秘钥
const IosAliAuthSdk =
    'T4fBIqVu+YX1H6gNBiIi76o/E3OH0qlo0Do+AtBY2IY9xZM8bzACCYh2hfyYPc4s5yAcEFNDdIgj2gaYDDG/YpdyJDI30HAUUw3wxTdISp5/TFVXeFhVkA0iiBPRh+eoYkOGOtRj+y9A==';
const AndroidAuthSdk =
    'SvhLsigI/nusTygMYGSEFEESA8a2WRv0HaYIS1S0pHXKOTGWVEoN12axM8S2vE0Mt8nY+jBP6/fnw2YMToikDpDc5zPNnhjkjsCtrkN0yYQlnB2Ar9lN9sLcxnLbkfv8bQMelLfQ/Ty0Era6VVjv9mv1vUy2OzuMPsyjtExf7S707p6pI7urEyVELy5sm2zhcBQhukD8TpH2glQ9lyXoH2aDcK387mTiPbOayKoVcOoOS35YxnfXTrFQlk8G6+mWAa1GxhlnVfYudo9ojs/EhXLFdODaCdkhaC6aNqSI4r+7N3/BI7xn8BZmDs+NkZlS';


class _MyAppState extends State<MyApp> {
  BuildContext mContext;

  @override
  void initState() {
    super.initState();
    // 初始化插件
    if (Platform.isAndroid) {
      AliAuthPlugin.initSdk(AndroidAuthSdk);
    } else {
      AliAuthPlugin.initSdk(IosAliAuthSdk);
    }
  }

  /// login 跳转到账号密码登录页
  void _doLogin() {}

  void _quickLogin() async {
    bool checkVerifyEnable = false;

    try {
      checkVerifyEnable = await AliAuthPlugin.checkVerifyEnable;
    } catch (e) {
      print('sdk error $e');
    }

    if (!checkVerifyEnable) {
      _doLogin();
      return;
    }

    if (checkVerifyEnable) {
      Map _result;

      try {
        _result = await AliAuthPlugin.login;
      } catch (e) {
        print('sdk error $e');
      }

      if (_result == null || _result['returnCode'] == PNSCodeFail) {
        _doLogin();
        return;
      }

      if (_result['returnCode'] == PNSCodeSuccess) {
        String _accessToken = _result['returnData'];
        /// 获取调token后走快速登录的的逻辑
      } else if (_result['returnCode'] == NSCodeLoginControllerClickChangeBtn) {
        /// 点击其他登录
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('阿里云一键登录'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            _quickLogin();
          },
          child: Text('登录'),
        ),
      ),
    );
  }
}
