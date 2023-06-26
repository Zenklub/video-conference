import VideoConference, {
  JitsiMeetEvent,
  CapabilitiesBuilder,
  JitsiMeetConferenceOptions,
} from '@zenklub/react-native-video-conference';

import React, { useEffect, useState } from 'react';
import {
  StyleSheet,
  Pressable,
  Text,
  ScrollView,
  SafeAreaView,
  View,
} from 'react-native';
import OptionsForm from './components/OptionsForm';

export interface JSONObject {
  [key: string]: string | JSONObject | unknown;
}

const capabilities = new CapabilitiesBuilder().build();

const conferenceOptions: JitsiMeetConferenceOptions = {
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
  const [options, setOptions] =
    useState<JitsiMeetConferenceOptions>(conferenceOptions);

  useEffect(() => {
    const remove = JitsiMeetEvent.addEventListener((event) => {
      console.log('EventType', event.type);
    });
    return () => {
      remove();
    };
  }, []);

  const onChangeOption = (text: string, name: string) => {
    setOptions((values) => ({ ...values, [name]: text }));
  };
  const resetOptions = () => {
    setOptions(conferenceOptions);
  };

  const onChangeUserInfo = (text: string, name: string) => {
    setOptions((values) => ({
      ...values,
      userInfo: { ...values.userInfo, [name]: text },
    }));
  };

  const startJitsiAsNativeController = async () => {
    try {
      await VideoConference.start(options);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <ScrollView contentContainerStyle={styles.containerScroll}>
      <SafeAreaView style={styles.container}>
        <View style={{ alignItems: 'flex-end', marginHorizontal: 20 }}>
          <Pressable
            onPress={resetOptions}
            style={({ pressed }) => [{ opacity: pressed ? 0.5 : 1 }]}
          >
            <Text style={styles.resetText}>Reset</Text>
          </Pressable>
        </View>
        <OptionsForm
          onChangeOption={onChangeOption}
          onChangeUserInfo={onChangeUserInfo}
          options={options}
        />
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
      </SafeAreaView>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  containerScroll: {
    flexGrow: 1,
  },
  pressable: {
    alignSelf: 'center',
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
  resetText: {
    fontSize: 16,
    fontWeight: 'bold',
    textAlign: 'center',
    color: '#222',
  },
  jitsiMeetView: {
    flex: 1,
  },
});

export default App;
