import axios from '../config';

const user = {
	query: data => axios.get('mock/5cdb726c9b6b1a0504a77803/example/query'),
};

export default user;
