import { StyleSheet, Text, TextInput, View } from 'react-native';
import React from 'react';
import { JitsiMeetConferenceOptions } from '@zenklub/react-native-video-conference';

interface Props {
  onChangeOption: (text: string, key: string) => void;
  onChangeUserInfo: (text: string, key: string) => void;
  options: JitsiMeetConferenceOptions;
}

const OptionsForm: React.FC<Props> = ({
  options,
  onChangeOption,
  onChangeUserInfo,
}) => {
  return (
    <View>
      <View style={styles.inputRow}>
        <Text style={styles.label}>Room:</Text>
        <TextInput
          value={options.room}
          style={styles.input}
          onChangeText={(text) => onChangeOption(text, 'room')}
        />
      </View>
      <View style={styles.inputRow}>
        <Text style={styles.label}>Server Url:</Text>
        <TextInput
          value={options.serverUrl}
          style={styles.input}
          onChangeText={(text) => onChangeOption(text, 'serverUrl')}
        />
      </View>
      {Object.entries(options.userInfo || {}).map(([key, value]) => (
        <View style={styles.inputRow} key={key}>
          <Text style={styles.label}>{key}:</Text>
          <TextInput
            defaultValue={value}
            style={styles.input}
            onChangeText={(text) => onChangeUserInfo(text, key)}
          />
        </View>
      ))}
    </View>
  );
};

export default OptionsForm;

const styles = StyleSheet.create({
  inputRow: { paddingVertical: 6, paddingHorizontal: 24 },
  input: {
    backgroundColor: '#eee',
    width: '100%',
    padding: 8,
    paddingVertical: 12,
    borderRadius: 8,
  },
  label: { fontWeight: 'bold', lineHeight: 24, textTransform: 'capitalize' },
});
