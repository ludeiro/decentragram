import React, { Component } from 'react';
import Web3 from 'web3';
import Identicon from 'identicon.js';
import './App.css';
import Decentragram from '../abis/Decentragram.json'
import Navbar from './Navbar'
import Main from './Main'


class App extends Component {

  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3
    let accounts = await web3.eth.getAccounts()
    this.setState( { account: accounts[0] })

    const networkId = await web3.eth.net.getId()
    const networkData = Decentragram.networks[networkId]

    if (networkData) {
      const decentragram = web3.eth.Contract(Decentragram.abi, networkData.address)
    }else{
      window.alert("Decentragram contract is not deployed in the detected network");
    }
    
  }

  constructor(props) {
    super(props)
    this.state = {
      name: 'Decentragram',
      account: this.props.account,
    }
  }

  render() {
    return (
      <div>
        <Navbar account={this.state.account} name={this.state.name} />
        { this.state.loading
          ? <div id="loader" className="text-center mt-5"><p>Loading...</p></div>
          : <Main
            // Code...
            />
          }
        }
      </div>
    );
  }
}

export default App;