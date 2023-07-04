import { VideoConferenceOptions } from '@zenklub/react-native-video-conference';
import React, { useState } from 'react';
import {
  StyleSheet,
  Pressable,
  Text,
  ScrollView,
  SafeAreaView,
  View,
  TouchableOpacity,
} from 'react-native';
import OptionsForm from './components/OptionsForm';
import ModalCapabilities from './components/ModalCapabilities';

interface Props {
  options: VideoConferenceOptions;
  onStart: () => void;
  onChangeOption: (text: string, name: string) => void;
  onChangeUserInfo: (text: string, name: string) => void;
  onChangeCapabilities: (text: string, value: boolean) => void;
  resetOptions: () => void;
}

const VideoConferenceExample: React.FC<Props> = ({
  options,
  onStart,
  onChangeOption,
  resetOptions,
  onChangeUserInfo,
  onChangeCapabilities,
}) => {
  const [visible, setVisible] = useState(false);
  return (
    <ScrollView contentContainerStyle={styles.containerScroll}>
      <ModalCapabilities
        visible={visible}
        capabilities={options.capabilities}
        onChangeCapabilities={onChangeCapabilities}
        onRequestClose={() => setVisible(false)}
      />
      <SafeAreaView style={styles.container}>
        <View style={styles.viewBtnReset}>
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

        <TouchableOpacity
          style={styles.buttonModal}
          onPress={() => setVisible(true)}
        >
          <Text style={styles.textButtonModal}>Update Flags</Text>
        </TouchableOpacity>

        <Pressable
          onPress={onStart}
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
};

const styles = StyleSheet.create({
  viewBtnReset: { alignItems: 'flex-end', marginHorizontal: 20 },
  container: {
    flex: 1,
  },
  containerScroll: {
    flexGrow: 1,
  },
  buttonModal: {
    alignSelf: 'center',
    marginVertical: 10,
  },
  textButtonModal: {
    fontSize: 16,
    color: 'blue',
    fontWeight: 'bold',
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

export default VideoConferenceExample;
