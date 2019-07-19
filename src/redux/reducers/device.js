import { fromJS } from 'immutable';
import { SET_DIRECTORIES, SET_DEVICEINFO, SET_GEOLOCATION } from '../constants/device';

const initialState = fromJS({
  directories: null,
  device: {
    imei: '',
  },
  location: null,
});

export default function deviceReducer(state = initialState, action) {
  switch (action.type) {
    case SET_DIRECTORIES:
      return state.set('directories', fromJS(action.data));
    case SET_DEVICEINFO:
      return state.set('device', fromJS({
        ...state.get('device').toJS(),
        ...action.data,
      }));
    case SET_GEOLOCATION:
      return state.set('location', fromJS(action.data));
    default:
      return state;
  }
}
