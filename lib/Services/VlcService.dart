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
            playlist.add({
              'id': item['id'],
              'filename': item['name'],
            });
            print('printing');
            print(item['name']);
            print(item['id']);
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

  Future<String> fetchCurrentlyPlaying()async{

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
        String currentlyPlaying  = '';

        if(data['children'] != null && data['children'].isNotEmpty){
          var items = data['children'][0]['children'];

          for(var item in items){
            if (item['current'] == 'current'){
              currentlyPlaying = item['name'];
            }
          }
        }

        return currentlyPlaying;

      }else{
        print('Failed to load currently Playing item ${response.statusCode}');
        return 'Nothing currently Playing';
      }
    }catch(e){
      throw Exception('Failed to load VLC playlist');
    }

  }

  void play(){
    sendCommand('pl_pause');
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
    sendCommand('chapter_next');
  }

  void previousChapter(){
    sendCommand('chapter_prev');
  }

  void fullscreen(){
    sendCommand('fullscreen');
  }


}