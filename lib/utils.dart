import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_service/contacts_service.dart';
import 'dart:developer';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class Command {
  static final all = [email, browser, call, contact, message, hello, time, roll, flash_on, flash_off, set_alarm, open, weather_status, bluetooth_on, bluetooth_off];
  static const email = 'write email';
  static const browser = 'browse';
  static const call = 'call';
  static const contact = 'contact';
  static const message = 'message';
  static const hello = 'hello';
  static const time = 'time';
  static const roll = 'roll';
  static const flash_on = 'turn on flashlight';
  static const flash_off = 'turn off flashlight';
  static const set_alarm = 'set alarm';
  static const open = 'open';
  static const weather_status = "what's the weather status";
  static const bluetooth_on = 'turn on bluetooth';
  static const bluetooth_off = 'turn off bluetooth';
}

final FlutterTts flutterTts = FlutterTts();
@override
void initState() {
  initState();
  initTts();
}
Future<void> initTts() async {
  await flutterTts.setLanguage('en-US');
  await flutterTts.setPitch(1.0);
  await flutterTts.setSpeechRate(0.5);
}


class Utils {
  static Future<void> scanText(String rawText)
  async {
    final text = rawText.toLowerCase();

    if (text.contains(Command.email))
    {
      final body = _getTextAfterCommand(text: text, command: Command.email);
      openEmail(body: body);
    }
    else if (text.contains(Command.browser))
    {
     final url = _getTextAfterCommand(text: text, command: Command.browser);
      openLink(url: url);
    }
    else if (text.contains(Command.call))
    {
      final num = _getTextAfterCommand(text: text, command: Command.call);
      callNum(body: num);
    }
    else if (text.contains(Command.contact))
    {
      String name = _getTextAfterCommand(text: text, command: Command.contact);
      name = name.toLowerCase();
      // String? varnum = await getContactNumber(name);
      // String num = varnum ?? "";
      // if(num=="")
      //   {
      //     speak('Contact not found');
      //   }
      String num = "";
      Map<String, int> mp = {
        "sample":1234,
        "abcd":5678
      };
      num = mp[name].toString();
      callNum(body: num);
    }
    else if(text.contains(Command.message))
    {
      final body = _getTextAfterCommand(text: text, command: Command.message);
      final b = extract_body(body);
      final num = extract_num(text);
      msg(body: b, num: num);
    }
    else if(text.contains(Command.hello))
      {
        speak('Hi there!');
      }
    else if(text.contains(Command.time))
      {
        var now = DateTime.now();
        var time = '${now.hour}:${now.minute}';
        speak('The time is $time');
      }
    else if(text.contains(Command.roll))
      {
        Random rnd = new Random();
        int min = 1;
        int max = 6;
        int r = min + rnd.nextInt(max - min);
        speak('You got $r');
      }
    else if(text.contains(Command.flash_on))
      {
        _turnOnFlash();
      }
    else if(text.contains(Command.flash_off))
    {
      _turnOffFlash();
    }
    else if(text.contains(Command.set_alarm))
      {
        int hh = 0;
        int mm = 0;
        String temp =  "";
        for(int i=text.length-1; i>=0; i--)
        {
          if(text[i]==":")
          {
            temp = reverseString(temp);
            mm = int.parse(temp);
            temp = "";
          }
          else if(text[i]==" ")
          {
            break;
          }
          else
          {
            temp = temp+text[i];
          }

        }
        temp = reverseString(temp);
        hh = int.parse(temp);

        FlutterAlarmClock.createAlarm(hh, mm);
      }
    else if(text.contains(Command.open))
      {
        Map<String, String> mp =
        {
          'paytm':'net.one97.paytm',
          'gallery':'com.miui.gallery',
          'whatsapp':'com.whatsapp',
        };
        final app_name = _getTextAfterCommand(text: text, command: Command.open);
        final link = mp[app_name];
        Application? app = await DeviceApps.getApp('${link}');
        bool isInstalled = await DeviceApps.isAppInstalled('${link}');
        if(isInstalled==true)
          {
            DeviceApps.openApp('${link}');
          }
        else
          {
            throw 'error';
          }
      }
    else if(text.contains(Command.weather_status))
      {
        final link = 'com.miui.weather2';
        Application? app = await DeviceApps.getApp('${link}');
        bool isInstalled = await DeviceApps.isAppInstalled('${link}');
        if(isInstalled==true)
        {
          DeviceApps.openApp('${link}');
        }
        else
        {
          throw 'error';
        }
      }
    else if(text.contains(Command.bluetooth_on))
      {
        turnOnBluetooth();
      }
    else if(text.contains(Command.bluetooth_off))
      {
        turnOffBluetooth();
      }
  }

  static String extract_body(String text)
  {
    int idx = -1;
    for(int i=text.length-1; i>=0; i--)
      {
        if(text[i]==" ")
          {
            idx = i;
            break;
          }
      }
    String ans = "";
    for(int i=0;i<=idx; i++)
      {
        ans+=text[i];
      }
    return ans;
  }

  static String extract_num(String text)
  {
    String ans = "";
    int n = text.length;
    for(int i=n-1; i>=0; i--)
      {
        if(text[i]==" ")
          {
            break;
          }
        else
          {
            ans = ans+text[i];
          }
      }
    var chars = ans.split('');
    return chars.reversed.join();
  }

  static String _getTextAfterCommand({required String text, required String command})
  {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;
    if (indexCommand == -1)
    {
      return "";
    }
    else
    {
      return text.substring(indexAfter).trim();
    }
  }

  static Future openLink({required String url}) async
  {
    if (url.trim().isEmpty)
    {
      await _launchUrl('https://google.com');
    }
    else
    {
      await _launchUrl('https://www.google.com/search?q=$url');
    }
  }

  static Future openEmail({required String body}) async
  {
    final url = 'mailto: ?body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }

  static Future callNum({required String body}) async
  {
    var u = body;
    final Uri url = Uri(scheme: "tel", path: u);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'error';
    }
  }

  static Future msg({required String body, required String num}) async
  {
    //log(body);
    final smsLaunchUri = 'sms:${Uri.encodeFull(num)}?body=${Uri.encodeFull(body)}';
    await _launchUrl(smsLaunchUri);
  }

  static Future _launchUrl(String url) async
  {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not launch $url';
    }
  }

  static Future<void> speak(String message) async
  {
    await flutterTts.speak(message);
  }

  // static Future<String?> getContactNumber(String nameQuery) async {
  //   final Iterable<Contact> contacts = await ContactsService.getContacts();
  //   final Contact? contact = contacts.firstWhere(
  //         (contact) => contact.displayName?.toLowerCase().contains(nameQuery.toLowerCase()) ??false,
  //   );
  //   return contact?.phones?.isNotEmpty == true ? contact!.phones!.first.value : null;
  // }

  // static Future<String?> getContactNumber(String nameQuery) async {
  //   nameQuery = nameQuery.toLowerCase();
  //   final Iterable<Contact> contacts = await ContactsService.getContacts();
  //   Contact? ans = null;
  //   for(final x in contacts)
  //     {
  //       if(x.displayName?.toLowerCase() == nameQuery)
  //         {
  //           ans = x;
  //           break;
  //         }
  //     }
  //   return ans?.phones?.isNotEmpty == true ? ans!.phones!.first.value : null;
  // }

   static Future<void> _turnOnFlash() async
  {
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
    }
  }

  static Future<void> _turnOffFlash() async
  {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
    }
  }

  static String reverseString(String input)
  {
    List<int> codeUnits = input.codeUnits;
    List<int> reversedCodeUnits = codeUnits.reversed.toList();
    String reversedString = String.fromCharCodes(reversedCodeUnits);
    return reversedString;
  }

  static Future<void> turnOnBluetooth() async {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    bool isAvailable = await flutterBlue.isAvailable;
    if (isAvailable)
    {
      bool isOn = await flutterBlue.isOn;
      if (!isOn)
      {
        await flutterBlue.turnOn();
        isOn = await flutterBlue.isOn;
        if (isOn)
        {
          print('Bluetooth turned on successfully.');
        }
        else
        {
          print('Failed to turn on Bluetooth.');
        }
      }
      else
      {
        speak('Bluetooth is already turned on');
      }
    }
    else
    {
      print('Bluetooth is not available on this device.');
    }
  }

  static Future<void> turnOffBluetooth() async {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    bool isAvailable = await flutterBlue.isAvailable;
    if (isAvailable)
    {
      bool isOn = await flutterBlue.isOn;
      if (isOn)
      {
        await flutterBlue.turnOff();
        isOn = await flutterBlue.isOn;
        if (!isOn)
        {
          print('Bluetooth turned off successfully.');
        }
        else
        {
          print('Failed to turn off Bluetooth.');
        }
      }
      else
      {
        speak('Bluetooth is already turned off');
      }
    }
    else
    {
      print('Bluetooth is not available on this device.');
    }
  }

}