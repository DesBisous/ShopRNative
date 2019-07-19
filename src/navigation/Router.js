import React from 'react';
import { Scene, Modal, Actions, Tabs, Lightbox } from 'react-native-router-flux';

import Home from '../containers/Home';

export default Actions.create(
  <Modal key="modal" hideNavBar>
    <Lightbox key="lightbox">
      <Scene key="root">
        <Tabs
          key="tab"
          hideNavBar
        >
          <Scene key="home" component={Home} title="首页"/>
          <Scene key="home2" component={Home} title="首页2"/>
        </Tabs>
      </Scene>
    </Lightbox>
  </Modal>
);
