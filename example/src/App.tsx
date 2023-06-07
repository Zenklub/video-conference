import VideoConference, {
  CapabilitiesBuilder,
} from '@zenklub/react-native-video-conference';

import React from 'react';
import { StyleSheet, View, Pressable, Text } from 'react-native';

const capabilities = new CapabilitiesBuilder().build();

const conferenceOptions = {
  room: 'ReactNativeJitsiRoom',
  serverUrl: 'https://meet.jit.si/',
  userInfo: {
    name: 'React Native Jitsi Meet Example',
    email: 'example@test.com',
    avatar: 'https://picsum.photos/200',
  },
  capabilities: capabilities,
};

function App() {
  const startJitsiAsNativeController = async () => {
    try {
      await VideoConference.start(conferenceOptions);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <View style={styles.container}>
      <Pressable
        onPress={startJitsiAsNativeController}
        style={({ pressed }) => [
          styles.pressable,
          { opacity: pressed ? 0.5 : 1 },
        ]}
      >
        <Text style={styles.pressableText}>
          Start Jitsi on top of RN Application
        </Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pressable: {
    width: '80%',
    borderRadius: 15,
    height: 50,
    marginVertical: 10,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'blue',
  },
  pressableText: {
    fontSize: 17,
    fontWeight: 'bold',
    textAlign: 'center',
    color: '#fff',
  },
  jitsiMeetView: {
    flex: 1,
  },
});

export default App;
