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


  Future<String?> sendCommand(String command, {String? value} )async{
    print('in Func1');
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
      print('in Func');
      if(response.statusCode == 200){
        print('Command executed successfully');
        return 'Command sent';


      }else{
        print('Failed to send command ${response.statusCode}');
      }

    }catch(e){
      print('Error: $e');
    }
    return null;
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
        print('Command executed successfully');

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

            print('Playlist');
            print('name:${item['name']}');
            print('id: ${item['id']}');
            print('Now playing: ${current}');
          }
        }

        return playlist;

      }else{
        print('Failed to load VLC playlist ${response.statusCode}');
        return [];
      }
    }catch(e){
      throw Exception('Failed to load VLC playlist');
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
        print('Command executed successfully');
        final data = jsonDecode(response.body);
        final data2 = jsonDecode(response2.body);

        Map<String, dynamic> currentlyStatus  = {};
        String currentlyPlaying = '';
        String duration = '';
        int volume = 0;

        print('Playlist JSON: ${jsonEncode(data)}');
        print('Status JSON: ${jsonEncode(data2)}');

        if(data['children'] != null && data['children'].isNotEmpty){
          var items = data['children'][0]['children'];
          // print(items);

          for(var item in items){
            print(item);
            if (item.containsKey('current')){
              print('Yeah its workiing');
              currentlyPlaying = item['name'];
              print(currentlyPlaying);
              // duration = item['duration'];
              // print(duration);
            }else{
              print('Nope its not workiing');
            }
          }
        }
        // if(data2 != null && data2.isNotEmpty){
        //    volume = int.parse(data2['volume']);
        //    print(volume);
        //
        //     }
        currentlyStatus = {
          'current': currentlyPlaying,
          // 'duration': duration,
          // 'volume': volume

        };

        return currentlyStatus;

      }else{
        print('Failed to load currently Playing item ${response.statusCode}');
        return {
          'current': 'Nothing currently playingss',
          'duration': '00:00',
          'volume': 0
        };
      }
    }catch(e){
       throw Exception('Failed to load VLC playlist');

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

  void nextChapter(){
    sendCommand('next_chapter');
  }

  void previousChapter(){
    sendCommand('prev_chapter');
  }

  void fullscreen(){
    sendCommand('fullscreen');
  }


}