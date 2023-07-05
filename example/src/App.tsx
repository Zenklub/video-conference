import VideoConference, {
  VideoConferenceEvent,
  CapabilitiesBuilder,
  VideoConferenceOptions,
  VideoConferenceEventType,
} from '@zenklub/react-native-video-conference';

import React, { useCallback, useEffect, useRef, useState } from 'react';

import AsyncStorage from '@react-native-async-storage/async-storage';

import VideoConferenceExample from './VideoConferenceExample';
import Loading from './components/Loading';
import { Alert } from 'react-native';

export interface JSONObject {
  [key: string]: string | JSONObject | unknown;
}

const capabilities = new CapabilitiesBuilder().build();

const conferenceOptions: VideoConferenceOptions = {
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
    useState<VideoConferenceOptions>(conferenceOptions);
  const [loading, setLoading] = useState(true);
  const removeRef = useRef<{ remove?: () => void }>({});

  const onSaveOptionOnStorage = (values: VideoConferenceOptions) => {
    AsyncStorage.setItem('VideoConferenceOptions', JSON.stringify(values));
  };

  const loaderAsyncOptions = async () => {
    try {
      const content = await AsyncStorage.getItem('VideoConferenceOptions');
      if (!content) throw new Error('Storage not found');
      setOptions(JSON.parse(content));
    } catch {
      setOptions(conferenceOptions);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loaderAsyncOptions();
  }, []);

  const eventListener = useCallback((event: VideoConferenceEventType) => {
    console.log('EventType', event.type, '\ndata:', event.data);
    if (!__DEV__ && event.type === 'conference-terminated') {
      Alert.alert(event.type, `data: ${JSON.stringify(event.data)}`);
    }
    if (event.type === 'ready-to-close') {
      removeRef.current.remove?.();
    }
  }, []);

  useEffect(() => {
    if (options) onSaveOptionOnStorage(options);
  }, [options]);

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
  const onChangeCapabilities = (text: string, value: boolean) => {
    setOptions((values) => ({
      ...values,
      capabilities: { ...values.capabilities, [text]: value },
    }));
  };

  const startJitsiAsNativeController = async () => {
    try {
      await VideoConference.start(options);
      removeRef.current.remove =
        VideoConferenceEvent.addEventListener(eventListener);
    } catch (err) {
      console.error(err);
    }
  };

  if (!options || loading) return <Loading />;

  return (
    <VideoConferenceExample
      options={options}
      onChangeOption={onChangeOption}
      onChangeUserInfo={onChangeUserInfo}
      onChangeCapabilities={onChangeCapabilities}
      resetOptions={resetOptions}
      onStart={startJitsiAsNativeController}
    />
  );
}

export default App;
