import VideoConference, {
  VideoConferenceEvent,
  CapabilitiesBuilder,
  VideoConferenceOptions,
} from '@zenklub/react-native-video-conference';

import React, { useEffect, useState } from 'react';

import AsyncStorage from '@react-native-async-storage/async-storage';

import VideoConferenceExample from './VideoConferenceExample';
import Loading from './components/Loading';

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

    const remove = VideoConferenceEvent.addEventListener((event) => {
      console.log('EventType', event.type, '\ndata:', event.data);
    });
    return () => {
      remove();
    };
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
      if (options) await VideoConference.start(options);
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
