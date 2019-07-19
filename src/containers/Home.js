import React, { Component } from 'react';
import { View, Text, Image } from 'react-native';
import Toast from 'react-native-root-toast';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { getVersion } from '../redux/actions/version';
import { userApi } from '../api';
import layouts from '../styles/common/layouts';

const mapStateToProps = state => {
	return {
		version: state.version.toJS(),
	};
};

const mapDispatchToProps = dispatch => {
	return {
		getVersion: bindActionCreators(getVersion, dispatch),
	};
};
class Home extends Component {
	constructor(props) {
		super(props);
		this.state = {
			test: 123,
		};
		this.testFunc = ::this.testFunc;
	}

	componentWillMount() {
		userApi.query().then(res => {
			if (res.code) {
				Toast.show('请求成功', layouts.toast);
			}
			console.log('res: ', res);
		});
		setTimeout(() => {
			console.log('定时器执行');
			this.props.getVersion();
		}, 2000);
	}

	testFunc() {
		console.log(this.state.test);
	}

	render() {
		return (
			<View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
				<Text onPress={this.testFunc}>Hello1 {this.props.version.no}</Text>
				{/*<Image source={require('../images/kv-1.jpg')} />*/}
			</View>
		);
	}
}
export default connect(
	mapStateToProps,
	mapDispatchToProps
)(Home);
