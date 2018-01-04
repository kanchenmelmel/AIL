// Tine Color: #4478B4
const DEBUG = false;
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));



const Icon = ({ name, ...props }) => <i className="material-icons" {...props}>{name}</i>;

class VedioItem extends React.Component {
    increaseViews = async () => {
        await fetch(`http://${DEBUG ? 'localhost:8888/wordpress/pte' : 'ail.vic.edu.au/PTE真题音频'}/increaseVideoVisitCount.php?title=${this.props.title}`).catch(console.error);
    }
    render() {
        const { title, url, views, duration } = this.props;
        const date = new Date(duration * 1000);
        const [ minutes, seconds ] = [ date.getMinutes(), date.getSeconds() ];
        const durationString = `${(minutes < 10 ? '0' : '') + minutes}:${(seconds < 10 ? '0' : '') + seconds}`;
        return (
            <div style={{ marginLeft: 8, marginRight: 8, paddingTop: 8, paddingBottom: 8, height: 80, display: 'flex', flexDirection: 'row', alignItems: 'stretch', borderBottom: '1px solid #EEEEEE' }}> 
                <div style={{ width: '40%', overflow: 'hidden' }}>
                    <video style={{ width: '100%', height: '100%', objectFit: 'cover' }} onPlay={this.increaseViews} controls>
                        <source src={url} type="video/mp4"/>
                    </video>
                </div>
                <div style={{ marginLeft: 8, maxWidth: '60%', flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'space-around' }}>
                    <p style={{ margin: 2, fontSize: 20, whiteSpace: 'nowrap', overflowX: 'auto' }}>{ title }</p>
                    <div style={{ margin: 2, marginLeft: 0, display: 'flex', flexDirection: 'row', alignItems: 'center', color: '#9E9E9E', fontSize: 13 }}>
                        <Icon name="play_arrow" style={{ fontSize: 18 }}/>
                        { views }
                        <Icon name="access_time" style={{ fontSize: 16, marginLeft: 15, marginRight: 1 }}/>
                        { durationString }
                    </div>
                </div>
            </div>
        );
    }
}

const Title = () => (
    <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'center', fontSize: 16, borderBottom: '1px solid #EEEEEE', padding: 8 }}>
        <p style={{ flex: 1, margin: 0, color: '#9E9E9E' }}>PTE视频课程</p>
    </div>
);

const Footer = () => (
    <div style={{ height: 30, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <p style={{ fontSize: 11, color: '#E0E0E0', margin: 0, fontWeight: 100 }}>© 2017 AUSTRALIAN INSTITUTE of LANGUAGE</p>
    </div>
);

const Loading = () => (
    <div style={{ height: window.innerHeight, display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 100 }}>
        <img src="loading.gif" height="40" width="40"/>
    </div>
);

function alertWithoutTitle(message) {
    const iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", 'data:text/plain,');
    document.documentElement.appendChild(iframe);
    window.frames[0].window.alert(message);
    iframe.parentNode.removeChild(iframe);
}

class Main extends React.Component {
    state = {
        data: undefined,
    }
    async componentDidMount() {
        const res = await fetch('http://ail.vic.edu.au/PTE真题音频/videos-data.php' + (
            window.USER_ID ? `?user_id=${window.USER_ID}` : ''
        ));
        const { data, vip } = await res.json();
        console.log(vip, data);
        if (!vip) {
            alertWithoutTitle('非会员仅能查看免费视频。');
        }
        this.setState({ data });
    }
    render() {
        if (!this.state.data) return <Loading/>;
        return (
            <div>
                <Title/>
                { Object.keys(this.state.data).map((k, i) => (
                    <VedioItem ref={k} key={i} title={k} {...this.state.data[k]}/>)
                ) }
                <Footer/>
            </div>
        );
    }
}

/*
console.log(window.ROLES);

if (!window.ROLES) {
    window.start = roles =>
        ReactDOM.render(<Main roles={roles}/>, document.getElementById('root'));
} else {
    ReactDOM.render(<Main roles={window.ROLES}/>, document.getElementById('root'));
}
*/
console.log(window.USER_ID);
ReactDOM.render(<Main/>, document.getElementById('root'));