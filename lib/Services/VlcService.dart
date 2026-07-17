import 'dart:convert';
import 'package:http/http.dart' as http;

class VlcService{

  late final String host;
  late final String port;
  late final String password;

  VlcService({
    required this.host,
    required this.port,
    required this.password,
});


  Future<bool> sendCommand(String command, {String? value} )async{
    final String query = value == null ? 'command=$command' : 'command=$command&val=$value';
    final url = Uri.parse('http://$host:$port/requests/status.xml?$query');
    final auth = 'Basic ${base64Encode(utf8.encode(':$password'))}';

    try{
      final response = await http.get(
        url,
        headers: {
          'Authorization': auth,
        },
      );

      if(response.statusCode == 200){
        return true;

      }else{
        return false;
      }

    }catch(e){
      print('Error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPlaylist()async{
    final url = Uri.parse('http://$host:$port/requests/playlist.json');
    final auth = 'Basic ${base64Encode(utf8.encode(':$password'))}';

    try{
      final response = await http.get(
        url,
        headers: {
          'Authorization': auth,
        },
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        List<Map<String, dynamic>> playlist = [];

        if(data['children'] != null && data['children'].isNotEmpty){
          var items = data['children'][0]['children'];

          for(var item in items){
            bool current = false;

            if(item.containsKey('current')){
                current = true;
                playlist.add({
                  'id': int.parse(item['id']),
                  'filename': item['name'],
                  'duration': item['duration'],
                  'playing': current
                });
            }else{
              playlist.add({
                'id': int.parse(item['id']),
                'filename': item['name'],
                'duration': item['duration'],
                'playing': current
              });
            }
          }
        }

        return playlist;

      }else{
        return [];
      }
    }catch(e){
      print('Failed to load VLC playlist');
      return [];
    }

  }

  Future <Map<String,dynamic>> fetchCurrentStatus()async{
    final url = Uri.parse('http://$host:$port/requests/playlist.json');
    final url2 = Uri.parse('http://$host:$port/requests/status.json');
    final auth = 'Basic ${base64Encode(utf8.encode(':$password'))}';

    try{
      final response = await http.get(
        url,
        headers: {
          'Authorization': auth,
        },
      );
      final response2 = await http.get(
        url2,
        headers: {
          'Authorization': auth,
        },
      );

      if(response.statusCode == 200 && response2.statusCode == 200){
        final data = jsonDecode(response.body);
        final data2 = jsonDecode(response2.body);

        Map<String, dynamic> currentlyStatus  = {};
        String currentlyPlaying = '';
        int volume = 0;
        String state = "";

        if(data['children'] != null && data['children'].isNotEmpty){
          var items = data['children'][0]['children'];

          for(var item in items){
            if (item.containsKey('current')){
              currentlyPlaying = item['name'];
            }
          }
        }
        if(data2 != null && data2.isNotEmpty){
           volume = data2['volume'];
           state = data2['state'];
        }

        currentlyStatus = {
          'current': currentlyPlaying,
          'volume': volume,
          'state': state == "stopped" || state == "paused" ? false : true,
          'success': true
        };

        return currentlyStatus;

      }else{
        return {
          'current': "",
          'volume': 0,
          'state': false,
          'success': false
        };
      }
    }catch(e){
       print('Failed to load current status');
       return {
         'current': "",
         'volume': 0,
         'state': false,
         'success': false
       };
    }

  }

  Stream<Map<String, dynamic>> fetchPlaybackInformation() async* {
    final url = Uri.parse('http://$host:$port/requests/status.json');
    final auth = 'Basic ${base64Encode(utf8.encode(':$password'))}';

    while (true) {
      try {
        final response = await http.get(
          url,
          headers: {
            'Authorization': auth,
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          int duration = 0;
          int currentTime = 0;
          int volume = 0;
          bool state = false;
          String currentlyPlaying = "";

          if (data != null && data.isNotEmpty) {

            if (data.containsKey('information') &&
                data['information'] != null &&
                data['information'].containsKey('category') &&
                data['information']['category'] != null &&
                data['information']['category'].containsKey('meta')) {
              final meta = data['information']['category']['meta'];
              currentlyPlaying = meta['filename'] ?? meta['title'] ?? "";
            }

            duration = data['length'] ?? 0;
            currentTime = data['time'] ?? 0;
            volume = data['volume'] ?? 0;
            state = data['state'] == "stopped" || data['state'] == "paused" ? false : true;
          }

          yield {
            'duration': duration,
            'currentTime': currentTime,
            'currentlyPlaying': currentlyPlaying,
            'volume': volume,
            'state': state,
            'success': true,
          };
        } else {
          yield {
            'duration': 0,
            'currentTime': 0,
            'currentlyPlaying': '',
            'volume': 0,
            'state': false,
            'success': false,
          };
        }
      } catch (e) {
        yield {
          'duration': 0,
          'currentTime': 0,
          'currentlyPlaying': '',
          'volume': 0,
          'state': false,
          'success': false,
        };
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future <Map<String,dynamic>> fetchChapterInformation()async{
    final url = Uri.parse('http://$host:$port/requests/status.json');
    final auth = 'Basic ${base64Encode(utf8.encode(':$password'))}';
    Map<String, dynamic> chapterInformation;

    try{
      final response = await http.get(
        url,
        headers: {
          'Authorization': auth,
        },
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        int currentChapter = 0;
        List<dynamic> chapters = [];

        if(data != null && data.isNotEmpty){
          if(data.containsKey('information')){
            currentChapter = data['information']['chapter'];
            chapters = data['information']['chapters'];
          }
        }

        chapterInformation = {
          'currentChapter': currentChapter,
          'chapters': chapters,
        };

        return chapterInformation;

      }else{
        return {
          'currentChapter': '',
          'chapters': [],
        };
      }
    }catch(e){
      print('Failed to load Chapter information');
      return {
        'currentChapter': '',
        'chapters': [],
      };
    }

  }

  void play(){
    sendCommand('pl_pause');
  }

  void playID(int id){
    sendCommand('pl_play&id=$id');
  }

  void next(){
    sendCommand('pl_next');
  }

  void previous(){
    sendCommand('pl_previous');
  }

  void stop(){
    sendCommand('pl_stop');
  }

  void addVolume(){
    sendCommand('volume',value: '+20');
  }

  void decreaseVolume(){
    sendCommand('volume',value: '-20');
  }

  void fastForward(){
    sendCommand('seek',value: '+10s');
  }

  void rewind(){
    sendCommand('seek',value: '-10s');
  }

  void seek({required int seconds}){
    sendCommand('seek', value: '$seconds');
  }

  void chapter({required int chapter}){
    sendCommand('chapter', value: '$chapter');
  }

  void fullscreen(){
    sendCommand('fullscreen');
  }



}