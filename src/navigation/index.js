import React, { Component } from 'react';
import { Router, Actions } from 'react-native-router-flux';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import appRoutes from './Router';
import { setCurrentScene } from '../utils/asyncStorage';
import * as deviceActions from '../redux/actions/device';
import {
	getGeolocation,
	getDirectories,
	getDeviceinfo,
	getSimInfo,
	getWifiInfo,
} from '../utils/getDevice';

class RouterContainer extends Component {
	constructor(props) {
		super(props);
		this.onStateChange = this.onStateChange.bind(this);
	}

	componentDidMount() {
		// 这里做一些初始化操作
		navigator.geolocation.requestAuthorization();
		getDeviceinfo.call(this);
		getWifiInfo.call(this);
		getSimInfo.call(this);
		getGeolocation.call(this);
		getDirectories.call(this);
	}

	onStateChange() {
		setCurrentScene(Actions.currentScene);
	}

	render() {
		return <Router scenes={appRoutes} onStateChange={this.onStateChange} />;
	}
}

export default connect(
	state => ({}),
	dispatch => ({
		deviceActions: bindActionCreators(deviceActions, dispatch),
	})
)(RouterContainer);
