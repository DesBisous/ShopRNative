import React from 'react';
import { View } from 'react-native';
import { Provider } from 'react-redux';
import Router from './navigation';
import configureStore from './configureStore';

// 隐藏yellowbox
console.disableYellowBox = true;

const initialState = {};
const store = configureStore(initialState);

const App = props => {
	return (
		<Provider store={store}>
			<View style={{ flex: 1 }}>
				<Router />
			</View>
		</Provider>
	);
};

export default App;
