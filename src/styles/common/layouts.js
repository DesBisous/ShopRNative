import Toast from 'react-native-root-toast';

const layout = {
	container: {
		position: 'relative',
		flex: 1,
		flexDirection: 'column',
		backgroundColor: '#fff',
	},
	absoluteCover: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		backgroundColor: 'rgba(52,52,52,0.5)',
	},
	none: {
		width: 0,
		height: 0,
		overflow: 'hidden',
	},
	toast: {
		position: Toast.positions.CENTER,
		duration: Toast.durations.LONG,
		backgroundColor: 'rgba(0,0,0,.8)',
		textColor: '#FFF',
	},
};

export default layout;
