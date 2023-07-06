import { VideoConferenceOptions } from '@zenklub/react-native-video-conference';
import {
  StyleSheet,
  Text,
  SafeAreaView,
  TouchableOpacity,
  FlatList,
  ListRenderItem,
  View,
  Switch,
  Modal,
} from 'react-native';
import React, { useCallback, useMemo } from 'react';
interface Props {
  visible?: boolean;
  onRequestClose: () => void;
  capabilities: VideoConferenceOptions['capabilities'];
  onChangeCapabilities: (text: string, value: boolean) => void;
}

interface DataItem {
  id: string;
  label: string;
  value: boolean;
}

const ModalCapabilities: React.FC<Props> = ({
  visible,
  onRequestClose,
  capabilities,
  onChangeCapabilities,
}) => {
  const data = useMemo(() => {
    return Object.entries(capabilities).map(([label, value], index) => ({
      id: index.toString(),
      label,
      value,
    }));
  }, [capabilities]);

  const renderItem = useCallback<ListRenderItem<DataItem>>(
    ({ item }) => {
      return (
        <View style={styles.itemContainer}>
          <Text style={styles.label}>{item.label}</Text>
          <Switch
            trackColor={{ false: '#f4f3f4', true: '#ddd' }}
            thumbColor={item.value ? '#6732D1' : '#3e3e3e'}
            ios_backgroundColor="#ddd"
            onValueChange={(value) => {
              onChangeCapabilities(item.label, value);
            }}
            value={item.value}
          />
        </View>
      );
    },
    [onChangeCapabilities]
  );

  return (
    <Modal visible={visible} onRequestClose={onRequestClose}>
      <SafeAreaView style={styles.container}>
        <View style={styles.header}>
          <Text style={styles.headerText}>Capabilities</Text>
        </View>
        <View style={styles.viewButton}>
          <TouchableOpacity style={styles.button} onPress={onRequestClose}>
            <Text style={[styles.buttonText]}>Close</Text>
          </TouchableOpacity>
        </View>
        <FlatList
          keyExtractor={(item) => item.id}
          data={data}
          renderItem={renderItem}
          style={styles.container}
          contentContainerStyle={styles.contentContainerStyle}
        />
      </SafeAreaView>
    </Modal>
  );
};

export default ModalCapabilities;

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  itemContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  viewButton: {
    paddingHorizontal: 20,
    paddingBottom: 8,
    flexDirection: 'row',
    justifyContent: 'space-between',
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  button: {
    padding: 8,
    borderRadius: 4,
    alignSelf: 'flex-end',
    backgroundColor: '#f1f1f1',
    justifyContent: 'center',
    alignItems: 'center',
  },
  header: {
    paddingBottom: 16,
    alignSelf: 'center',
  },
  buttonText: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  label: {
    fontSize: 16,
    fontWeight: '500',
  },
  headerText: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  contentContainerStyle: {
    flexGrow: 1,
    padding: 20,
  },
});
